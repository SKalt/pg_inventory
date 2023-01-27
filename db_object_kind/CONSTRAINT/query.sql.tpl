{{- $is_fk := (eq .kind "f") -}}
{{- $is_generic := (eq .kind ":") -}}
{{- $is_all := (eq .kind "") -}}
{{- $show_fk := or ($is_all) ($is_fk) -}}
SELECT
  -- constraint namespacing
    {{ if .oid -}}
    constraint_.oid
    , constraint_.connamespace AS schema_oid
    {{ else -}} ns.nspname AS schema_name
    {{ end -}}
    , constraint_.conname AS "name"
  -- constraint enforcement info
{{- if and $is_all (not .packed) }}
    , constraint_.contype AS constraint_type
      -- c => check
      -- f => foreign key
      -- p => primary key
      -- t => constraint trigger
      -- u => unique
      -- x => exclusion
{{- end }}
{{- if .packed }}
    , (-- info: a 2-byte packed int.
        0
        -- 0000 0000 0000 0111 : constraint type
          {{- if .kind }} -- omitted since constraint type is specified
          {{- else }}
          | ((
              CASE constraint_.contype -- constraint type
                WHEN 'c' THEN 1 -- check
                WHEN 'f' THEN 2 -- foreign key
                WHEN 'p' THEN 3 -- primary key
                WHEN 't' THEN 4 -- constraint trigger
                WHEN 'u' THEN 5 -- unique
                WHEN 'x' THEN 6 -- exclusion
                ELSE          0
              END
            )<<0)
          {{- end }}
        -- 0000 0000 0011 1000 : FK update action
          {{- if not $show_fk }} -- omitted since only non-FK constraints matched
          {{- else }}
          | ((
              CASE constraint_.confmatchtype
                WHEN 'f' THEN 1 -- f => full
                WHEN 'p' THEN 2 -- p => partial
                WHEN 's' THEN 3 -- s => simple
                ELSE 0
              END
            )<<3)
          {{- end }}
        -- 0000 0000 1100 0000 : FK match type
          {{- if not $show_fk }} -- omitted since only non-FK constraints matched
          {{- else }}
          | ((
            CASE constraint_.confupdtype
              WHEN 'a' THEN 1 -- no action
              WHEN 'r' THEN 2 -- restrict
              WHEN 'c' THEN 3 -- cascade
              WHEN 'n' THEN 4 -- set null
              WHEN 'd' THEN 5 -- set default
              ELSE          0
            END
          )<<6)
          {{- end }}
        -- 0000 0111 0000 0000 : FK delete action
          {{- if not $show_fk }} -- omitted since only non-FK constraints matched
          {{- else }}
          | ((
              CASE constraint_.confdeltype
                WHEN 'a' THEN 1 -- no action
                WHEN 'r' THEN 2 -- restrict
                WHEN 'c' THEN 3 -- cascade
                WHEN 'n' THEN 4 -- set null
                WHEN 'd' THEN 5 -- set default
                ELSE          0
              END
            )<<8)
          {{- end }}
        -- 0000 1000 0000 0000 : is_deferrable
          | CASE WHEN constraint_.condeferrable THEN 1<<11 ELSE 0 END
        -- 0001 0000 0000 0000 : is_deferred_by_default
          | CASE WHEN constraint_.condeferred   THEN 1<<12 ELSE 0 END
        -- 0010 0000 0000 0000 : is_local (to a relation; heritable)
          | CASE WHEN constraint_.conislocal    THEN 1<<13 ELSE 0 END
        -- 0100 0000 0000 0000 : not_inheritable
          | CASE WHEN constraint_.connoinherit  THEN 1<<14 ELSE 0 END
        -- 1000 0000 0000 0000 : is_validated
          * CASE WHEN constraint_.convalidated  THEN 1 ELSE -1 END
      )::INT2 AS info
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
  {{- if .oid }}
    , constraint_.conrelid AS relation_oid
      -- always 0 for non-table constraints
    , constraint_.conparentid AS parent_constraint_oid -- can be 0
  {{- else }}
    , tbl_ns.nspname AS table_schema
    , tbl.relname AS table_name
      -- always null for non-table constraints
    , parent_constraint_schema.nspname AS parent_constraint_schema
    , parent_constraint.conname AS parent_constraint
  {{- end }}
      -- if this is a constraint on a partition, the constraint of the
      -- parent partitioned table.
    , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
  -- domain information
  {{- if $is_fk }} -- omitted for fks
  {{- else if .oid }}
    , constraint_.contypid AS type_oid -- always 0 for non-domain constraints
  {{- else }}
    , type_ns.nspname AS type_schema
    , type_.typname AS type_name
      -- always null for non-domain constraints
  {{- end }}
  -- other
    , constraint_.coninhcount AS n_ancestor_constraints
      -- number of inheritence ancestors. If nonzero, can't be dropped or renamed
    , constraint_.conkey AS constrained_column_numbers
      -- int2[] list of the constrained columns (references pg_attribute.attnum)
      -- Populated iff the constraint is a table constraint (including foreign
      -- keys, but not constraint triggers)
{{- if $show_fk }}
{{- if .oid }}
    , constraint_.confrelid AS referenced_table_oid
    -- fk comparison operator oids: oid[] each referencing pg_catalog.pg_operator.oid
    -- TODO: figure out how to map those OID arrays to schema-qualified names
    , constraint_.conpfeqop AS pk_fk_equality_comparison_operator_oids
    , constraint_.conppeqop AS pk_pk_equality_comparison_operator_oids
    , constraint_.conffeqop AS fk_fk_equality_comparison_operator_oids
{{- else }}
  -- fk referenced table info
    , referenced_tbl_ns.nspname AS referenced_table_schema
    , referenced_tbl.relname AS referenced_table_name
    , constraint_.confkey AS foreign_key_column_numbers
      -- int2[] (each reference pg_attribute.attnum)
      -- list of the columns the FK references
{{- end }}
{{- end }}
    , constraint_.conexclop AS per_column_exclusion_operator_oids
      -- oid[] each referencing pg_catalog.pg_operator.oid
    , pg_catalog.obj_description(constraint_.oid, 'pg_constraint') AS "comment"
FROM (
  SELECT *
  FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
  {{- if .kind }}
  {{- if $is_fk }}
  WHERE constraint_.contype = 'f'
  {{- else }}
  WHERE constraint_.contype != 'f' AND constraint_.contype = :'kind'
  {{- end }}
    -- c => check
    -- f => foreign key
    -- p => primary key
    -- t => constraint trigger
    -- u => unique
    -- x => exclusion
  {{- end }}
) AS constraint_
{{ if not .oid -}}
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON constraint_.connamespace = ns.oid
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
LEFT JOIN (
  pg_catalog.pg_constraint AS parent_constraint
  INNER JOIN pg_catalog.pg_namespace AS parent_constraint_schema
    ON parent_constraint.connamespace = parent_constraint_schema.oid
) ON constraint_.conparentid = parent_constraint.oid
{{ end -}}