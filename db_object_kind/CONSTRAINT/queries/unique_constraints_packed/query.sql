SELECT
-- constraint namespacing
    ns.nspname AS constraint_schema
  , constraint_.connamespace AS constraint_schema_oid
  , constraint_.conname AS constraint_name
  , constraint_.oid AS constraint_oid
-- constraint enforcement info
  , (/* enforcement_info: a 2-byte struct of the form
      00000000 00000000
      -----    ~~~~~~ *
      bools    type     validation
    */
    CAST(0 as INT2)
    | CASE WHEN constraint_.condeferrable THEN 1<<0 ELSE 0 END
    | CASE WHEN constraint_.condeferred   THEN 1<<1 ELSE 0 END
    | CASE WHEN constraint_.convalidated  THEN 1<<2 ELSE 0 END
    | CASE WHEN constraint_.conislocal    THEN 1<<3 ELSE 0 END
    | CASE WHEN constraint_.connoinherit  THEN 1<<4 ELSE 0 END
    | (
        CASE constraint_.contype -- constraint type
          WHEN 'c' THEN 1<<8  -- check
          WHEN 'f' THEN 1<<9  -- foreign key
          WHEN 'p' THEN 1<<10 -- primary key
          WHEN 't' THEN 1<<11 -- constraint trigger
          WHEN 'u' THEN 1<<12 -- unique
          WHEN 'x' THEN 1<<13 -- exclusion
          ELSE          1<<15 -- validation bit
        END
      )
    ) AS enforcement_info
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
FROM pg_catalog.pg_constraint AS constraint_ -- https://www.postgresql.org/docs/current/catalog-pg-constraint.html
INNER JOIN pg_catalog.pg_namespace AS ns-- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON constraint_.contype = 'u'
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
