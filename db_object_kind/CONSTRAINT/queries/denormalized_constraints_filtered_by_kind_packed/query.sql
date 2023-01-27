SELECT
  -- constraint namespacing
    ns.nspname AS schema_name
    , constraint_.conname AS "name"
  -- constraint enforcement info
    , (-- info: a 2-byte packed int.
        0
        -- 0000 0000 0000 0111 : constraint type -- omitted since constraint type is specified
        -- 0000 0000 0011 1000 : FK update action -- omitted since only non-FK constraints matched
        -- 0000 0000 1100 0000 : FK match type -- omitted since only non-FK constraints matched
        -- 0000 0111 0000 0000 : FK delete action -- omitted since only non-FK constraints matched
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
  -- table constraint information
    , tbl_ns.nspname AS table_schema
    , tbl.relname AS table_name
      -- always null for non-table constraints
    , parent_constraint_schema.nspname AS parent_constraint_schema
    , parent_constraint.conname AS parent_constraint
      -- if this is a constraint on a partition, the constraint of the
      -- parent partitioned table.
    , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
  -- domain information
    , type_ns.nspname AS type_schema
    , type_.typname AS type_name
      -- always null for non-domain constraints
  -- other
    , constraint_.coninhcount AS n_ancestor_constraints
      -- number of inheritence ancestors. If nonzero, can't be dropped or renamed
    , constraint_.conkey AS constrained_column_numbers
      -- int2[] list of the constrained columns (references pg_attribute.attnum)
      -- Populated iff the constraint is a table constraint (including foreign
      -- keys, but not constraint triggers)
    , constraint_.conexclop AS per_column_exclusion_operator_oids
      -- oid[] each referencing pg_catalog.pg_operator.oid
    , pg_catalog.obj_description(constraint_.oid, 'pg_constraint') AS "comment"
FROM (
  SELECT *
  FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
  WHERE constraint_.contype != 'f' AND constraint_.contype = :'kind'
    -- c => check
    -- f => foreign key
    -- p => primary key
    -- t => constraint trigger
    -- u => unique
    -- x => exclusion
) AS constraint_
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON constraint_.connamespace = ns.oid
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
