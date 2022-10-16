SELECT
-- constraint namespacing
    ns.nspname AS constraint_schema
  , constraint_.conname AS constraint_name
-- constraint enforcement info
  , constraint_.condeferrable AS is_deferrable
  , constraint_.condeferred AS is_deferred_by_default
  , constraint_.convalidated AS is_validated
    -- currently falsifiable only for fk and check
  , constraint_.conislocal AS is_local
    -- the constraint is defined within the relation (can be inherited, too)
  , constraint_.connoinherit AS not_inheritable
    -- not inheritabe AND local to the relation
-- table constraint information
  , tbl_ns.nspname AS table_schema
  , tbl.relname AS table_name
    -- always null for non-table constraints
  , parent_constraint_schema.nspname AS parent_constraint_schema
  , parent_constraint.conname AS parent_constraint
    -- if this is a constraint on a partition, the oid of the constraint of the
    -- parent partitioned table. Zero if the constraint doesn't correspond to
    -- a constraint on a partitioned table.
  , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
-- domain information
  , type_ns.nspname AS type_schema
  , type_.typname AS type_name
    -- always 0 for non-domain constraints
  , constraint_.coninhcount AS n_ancestor_constraints
    -- number of inheritence ancestors. If nonzero, can't be dropped or renamed
  , constraint_.conkey AS constrained_column_numbers
    -- int2[] list of the constrained columns (references pg_attribute.attnum)
    -- Populated iff the constraint is a table constraint (including foreign
    -- keys, but not constraint triggers)
  , constraint_.conexclop AS per_column_exclusion_operator_oids
    -- oid[] each referencing pg_catalog.pg_operator.oid
FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON constraint_.contype = 'x'
  AND constraint_.connamespace = ns.oid
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