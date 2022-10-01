SELECT
-- constraint namespacing
    ns.nspname AS constraint_schema
  , constraint_.connamespace AS constraint_schema_id
  , constraint_.oid AS constraint_oid
  , constraint_.conname AS constraint_name
-- constraint enforcement info
  , constraint_.contype AS constraint_type
    -- c => check
    -- f => foreign key
    -- p => primary key
    -- t => constraint trigger
    -- u => unique
    -- x => exclusion
  , constraint_.condeferrable AS is_deferrable
  , constraint_.condeferred AS is_deferred_by_default
  , constraint_.convalidated AS is_validated
    -- currently falsifiable only for fk and check
  , constraint_.conislocal AS is_local
    -- the constraint is defined within the relation (can be inherited, too)
  , constraint_.connoinherit AS not_inheritable
    -- not inheritabe AND local to the relation
-- FK update codes
  , CASE constraint_.contype WHEN 'f' THEN constraint_.confupdtype ELSE NULL END AS fk_update_action_code
    -- fk update action code:
    -- a => no action
    -- r => restrict
    -- c => cascade
    -- n => set null
    -- d => set default
  , CASE constraint_.contype WHEN 'f' THEN constraint_.confdeltype ELSE NULL END AS fk_delete_action_code -- same codes as fk update
  , ( -- fk_match_type
      CASE constraint_.contype
        WHEN 'f' THEN constraint_.confmatchtype
        ELSE NULL
      END
    ) AS fk_match_type
    -- f => full
    -- p => partial
    -- s => simple
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
FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON constraint_.connamespace = ns.oid
LEFT JOIN pg_catalog.pg_class AS referenced_tbl
  ON constraint_.confrelid = referenced_tbl.oid
LEFT JOIN pg_catalog.pg_namespace AS referenced_tbl_ns
  ON referenced_tbl.relnamespace = referenced_tbl_ns.oid
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