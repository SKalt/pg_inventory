SELECT
  -- namespacing
      ns.nspname AS schema_name
    , tbl.relname AS table_name
    , trigger_.tgname AS "name" -- must be unique among triggers of same table
    , trigger_.tgparentid AS parent_trigger_oid
      -- Parent trigger that this trigger is cloned from (this happens when
      -- partitions are created or attached to a partitioned table); zero if not
      -- a clone
    , handler_fn_schema.nspname AS handler_fn_schema
    , handler_fn.proname AS handler_fn
    , trigger_.tgtype AS trigger_type -- int2 bitmask identifying trigger firing conditions
    , ( -- info: int2
        -- 0000 0000 0000 0111 -- bools
        -- 0000 0000 0011 0000 -- session_replication_role_firing_mode
        0
        | CASE WHEN trigger_.tgisinternal THEN 1<<0 ELSE 0 END
        | CASE WHEN trigger_.tgdeferrable THEN 1<<1 ELSE 0 END
        | CASE WHEN trigger_.tginitdeferred THEN 1<<2 ELSE 0 END
        | (
            CASE trigger_.tgenabled
              WHEN 'O' THEN 1<<4 -- in "origin" and "local" modes
              WHEN 'D' THEN 2<<4 -- disabled
              WHEN 'R' THEN 3<<4 -- in "replica" mode
              WHEN 'A' THEN 4<<4 -- always.
              ELSE 0
            END
          )
      ) AS info
  , trigger_.tgnargs AS n_args -- int2, number of args for trigger fn
  , trigger_.tgattr AS col_numbers
    -- int2vector (references pg_attribute.attnum)
    -- Column numbers, if trigger is column-specific; otherwise an empty array
  , ref_schema.nspname AS referenced_table_schema
  , ref.relname AS referenced_table_name
    -- The table referenced by a referential integrity constraint (zero if
    -- trigger is not for a referential integrity constraint)
  , constraint_schema.nspname AS constraint_schema
  , constraint_.conname AS constraint_name
    -- The pg_constraint entry associated with the trigger (zero if trigger is
    -- not for a constraint)
  , trigger_.tgconstrindid AS constraint_index_oid
    -- The index supporting a unique, primary key, referential integrity, or
    -- exclusion constraint (zero if trigger is not for one of these types of
    --  constraint)
  , trigger_.tgargs AS args -- bytea
    -- Argument strings to pass to trigger, each NULL-terminated
  , trigger_.tgoldtable AS old_table_name -- in REFERENCING clause, if any
  , trigger_.tgnewtable AS old_table_name -- in REFERENCING clause, if any
  , pg_catalog.pg_get_triggerdef(trigger_.oid, true) AS trigger_def
FROM pg_catalog.pg_trigger AS trigger_
INNER JOIN pg_catalog.pg_class AS tbl
  ON trigger_.tgrelid = tbl.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON tbl.relnamespace = ns.oid

LEFT JOIN ( -- TODO: inner join?
  pg_catalog.pg_proc AS handler_fn
  INNER JOIN pg_catalog.pg_namespace AS handler_fn_schema
  ON handler_fn.pronamespace = handler_fn_schema.oid
) ON trigger_.tgfoid = handler_fn.oid

LEFT JOIN (
  pg_catalog.pg_class AS ref
  INNER JOIN pg_catalog.pg_namespace AS ref_schema
    ON ref.relnamespace = ref_schema.oid
) ON trigger_.tgconstrrelid = ref.oid

LEFT JOIN (
  pg_catalog.pg_constraint AS constraint_
  INNER JOIN pg_catalog.pg_namespace AS constraint_schema
    ON constraint_.connamespace = constraint_schema.oid
) ON trigger_.tgconstraint > 0 AND trigger_.tgconstraint = constraint_.oid
