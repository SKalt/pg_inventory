SELECT
  -- constraint namespacing
    constraint_.oid
    , constraint_.connamespace AS schema_oid
    , constraint_.conname AS "name"
  -- constraint enforcement info
    , (-- info: a 2-byte packed int.
        0
        -- 0000 0000 0000 0111 : constraint type
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
        -- 0000 0000 0011 1000 : FK update action
          | ((
              CASE constraint_.confmatchtype
                WHEN 'f' THEN 1 -- f => full
                WHEN 'p' THEN 2 -- p => partial
                WHEN 's' THEN 3 -- s => simple
                ELSE 0
              END
            )<<3)
        -- 0000 0000 1100 0000 : FK match type
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
        -- 0000 0111 0000 0000 : FK delete action
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
    , constraint_.conrelid AS relation_oid
      -- always 0 for non-table constraints
      -- if this is a constraint on a partition, the constraint of the
      -- parent partitioned table.
    , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
  -- domain information
    , constraint_.contypid AS type_oid -- always 0 for non-domain constraints
  -- fk info
    , constraint_.confrelid AS referenced_table_oid
    -- fk comparison operator oids: oid[] each referencing pg_catalog.pg_operator.oid
    , constraint_.conpfeqop AS pk_fk_equality_comparison_operator_oids
    , constraint_.conppeqop AS pk_pk_equality_comparison_operator_oids
    , constraint_.conffeqop AS fk_fk_equality_comparison_operator_oids
    , constraint_.confkey AS foreign_key_column_numbers
      -- int2[] (each reference pg_attribute.attnum)
      -- list of the columns the FK references
  -- other
    , constraint_.conparentid AS parent_constraint_oid -- can be 0
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
) AS constraint_
