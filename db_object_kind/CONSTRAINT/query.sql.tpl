{{ $is_fk := (eq .kind "f") -}}
{{ $show_fk := or (not .kind) ($is_fk) -}}
SELECT
-- constraint namespacing
    ns.nspname AS constraint_schema
  , constraint_.connamespace AS constraint_schema_oid
  , constraint_.conname AS constraint_name
  , constraint_.oid AS constraint_oid
-- constraint enforcement info
{{- if and (not .kind) (not .packed) }}
  , constraint_.contype AS constraint_type
    -- c => check
    -- f => foreign key
    -- p => primary key
    -- t => constraint trigger
    -- u => unique
    -- x => exclusion
{{- end }}
{{- if .packed }}
  , (/* enforcement_info: a 2-byte struct of the form
      0000 0000 0001 1111 : bools
      0000 0000 1110 0000 : constraint type
    */
    CAST(0 as INT2)
    | CASE WHEN constraint_.condeferrable THEN 1<<0 ELSE 0 END
    | CASE WHEN constraint_.condeferred   THEN 1<<1 ELSE 0 END
    | CASE WHEN constraint_.convalidated  THEN 1<<2 ELSE 0 END
    | CASE WHEN constraint_.conislocal    THEN 1<<3 ELSE 0 END
    | CASE WHEN constraint_.connoinherit  THEN 1<<4 ELSE 0 END
    {{- if not .kind }}
    | (({{/* always include type in packed struct since we have room */}}
        CASE constraint_.contype -- constraint type
          WHEN 'c' THEN 1 -- check
          WHEN 'f' THEN 2 -- foreign key
          WHEN 'p' THEN 3 -- primary key
          WHEN 't' THEN 4 -- constraint trigger
          WHEN 'u' THEN 5 -- unique
          WHEN 'x' THEN 6 -- exclusion
          ELSE          0
        END
      )<<5)
    {{- end }}
    )::INT2 AS enforcement_info
{{- if $show_fk }}
  , (/* fk_info: a 2-byte packed struct of the form
      0000 0000 0000 0011 : match type
      0000 0000 0001 1100 : update action
      0000 0000 1110 0000 : delete action
    */
    CAST(0 as INT2)
    | ((
        CASE constraint_.confmatchtype
          WHEN 'f' THEN 1 -- f => full
          WHEN 'p' THEN 2 -- p => partial
          WHEN 's' THEN 3 -- s => simple
          ELSE 0
        END
      )<<0)
    | ((
        CASE constraint_.confupdtype
          WHEN 'a' THEN 1 -- no action
          WHEN 'r' THEN 2 -- restrict
          WHEN 'c' THEN 3 -- cascade
          WHEN 'n' THEN 4 -- set null
          WHEN 'd' THEN 5 -- set default
          ELSE          0
        END
      )<<2)
    | ((
        CASE constraint_.confdeltype
          WHEN 'a' THEN 1 -- no action
          WHEN 'r' THEN 2 -- restrict
          WHEN 'c' THEN 3 -- cascade
          WHEN 'n' THEN 4 -- set null
          WHEN 'd' THEN 5 -- set default
          ELSE          0
        END
      )<<5)
  )::INT2 AS fk_info
{{- end -}}
{{- else }}
  , constraint_.condeferrable AS is_deferrable
  , constraint_.condeferred AS is_deferred_by_default
  , constraint_.convalidated AS is_validated
    -- currently falsifiable only for fk and check
  , constraint_.conislocal AS is_local
    -- the constraint is defined within the relation (can be inherited, too)
  , constraint_.connoinherit AS not_inheritable
    -- not inheritabe AND local to the relation
{{- if $show_fk }}
-- FK update codes
{{- if $is_fk }}
  , constraint_.confupdtype
{{- else }}
  , CASE constraint_.contype WHEN 'f' THEN constraint_.confupdtype ELSE NULL END
{{- end }} AS fk_update_action_code
    -- fk update action code:
    -- a => no action
    -- r => restrict
    -- c => cascade
    -- n => set null
    -- d => set default
{{- if $is_fk }}
  , constraint_.confdeltype
{{- else }}
  , CASE constraint_.contype WHEN 'f' THEN constraint_.confdeltype ELSE NULL END
{{- end }} AS fk_delete_action_code -- same codes as fk update
{{- if $is_fk }}
  , constraint_.confmatchtype
{{- else }}
  , ( -- fk_match_type
      CASE constraint_.contype
        WHEN 'f' THEN constraint_.confmatchtype
        ELSE NULL
      END
    )
{{- end }} AS fk_match_type
    -- f => full
    -- p => partial
    -- s => simple
{{- end }}
{{- end }}
-- table constraint information
  , tbl_ns.nspname AS table_schema
  , tbl.relnamespace AS table_schema_oid
  , tbl.relname AS table_name
  , constraint_.conrelid AS table_oid
    -- always 0 for non-table constraints
  , constraint_.conparentid AS partition_parent_constraint_oid
    -- if this is a constraint on a partition, the oid of the constraint of the
    -- parent partitioned table. Zero if the constraint doesn't correspond to
    -- a constraint on a partitioned table.
  , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
-- domain information
  , type_ns.nspname AS type_schema
  , type_.typnamespace AS type_schema_oid
  , type_.typname AS type_name
  , constraint_.contypid AS type_oid
    -- always 0 for non-domain constraints
  , constraint_.coninhcount AS n_ancestor_constraints
    -- number of inheritence ancestors. If nonzero, can't be dropped or renamed
  , constraint_.conkey AS constrained_column_numbers
    -- int2[] list of the constrained columns (references pg_attribute.attnum)
    -- Populated iff the constraint is a table constraint (including foreign
    -- keys, but not constraint triggers)
{{- if $show_fk }}
-- fk referenced table info
  , referenced_tbl_ns.nspname AS referenced_table_schema
  , referenced_tbl.relnamespace AS referenced_table_schema_oid
  , referenced_tbl.relname AS referenced_table_name
  , constraint_.confrelid AS referenced_table_oid
  , constraint_.confkey AS foreign_key_column_numbers
    -- int2[] (each reference pg_attribute.attnum)
    -- list of the columns the FK references
-- fk comparison operator oids: oid[] each referencing pg_catalog.pg_operator.oid
  , constraint_.conpfeqop AS pk_fk_equality_comparison_operator_oids
  , constraint_.conppeqop AS pk_pk_equality_comparison_operator_oids
  , constraint_.conffeqop AS fk_fk_equality_comparison_operator_oids
{{- else if or (not .kind) (eq .kind "x") }}
  , constraint_.conexclop AS per_column_exclusion_operator_oids
    -- oid[] each referencing pg_catalog.pg_operator.oid
{{- end }}
FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON {{- if .kind }} constraint_.contype = '{{.kind}}'
  AND {{- end }} constraint_.connamespace = ns.oid
{{- if $show_fk }}
{{- if not $is_fk }}
LEFT{{ else }}
INNER{{ end }} JOIN pg_catalog.pg_class AS referenced_tbl
  ON constraint_.confrelid = referenced_tbl.oid
{{- if not $is_fk }}
LEFT{{ else }}
INNER{{ end }} JOIN pg_catalog.pg_namespace AS referenced_tbl_ns
  ON referenced_tbl.relnamespace = referenced_tbl_ns.oid
{{- end }}
LEFT JOIN (
    pg_catalog.pg_class AS tbl -- https://www.postgresql.org/docs/current/catalog-pg-class.html
    INNER JOIN pg_catalog.pg_namespace AS tbl_ns ON tbl.relnamespace = tbl_ns.oid
  )
  ON constraint_.conrelid > 0 -- always 0 for non-table constraints
  AND constraint_.conrelid = tbl.oid
LEFT JOIN (
    pg_catalog.pg_type AS type_
    INNER JOIN pg_catalog.pg_namespace AS type_ns ON type_.typnamespace = type_ns.oid
  )
  ON constraint_.contypid > 0
  AND constraint_.contypid = type_.oid
