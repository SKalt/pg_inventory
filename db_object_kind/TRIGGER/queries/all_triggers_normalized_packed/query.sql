SELECT
  -- namespacing
      trigger_.oid
    , trigger_.tgrelid AS table_oid
  -- trigger details
    , trigger_.tgname AS "name" -- must be unique among triggers of same table
    , trigger_.tgparentid AS parent_trigger_oid -- 0 if trigger not a clone
      -- Parent trigger that this trigger is cloned from (this happens when
      -- partitions are created or attached to a partitioned table)
    , trigger_.tgfoid AS handler_fn_oid
    , trigger_.tgtype AS trigger_type -- int2 bitmask identifying trigger firing conditions
    , ( -- info: int2
        0
        -- 0000 0000 0000 0001 -- is_internal
          | CASE WHEN trigger_.tgisinternal THEN 1<<0 ELSE 0 END
        -- 0000 0000 0000 0010 -- is_deferrable
          | CASE WHEN trigger_.tgdeferrable THEN 1<<1 ELSE 0 END
        -- 0000 0000 0000 0100 -- is_deferred
          | CASE WHEN trigger_.tginitdeferred THEN 1<<2 ELSE 0 END
        -- 0000 0000 0011 1000 -- session_replication_role_firing_mode
          | (
              CASE trigger_.tgenabled
                WHEN 'O' THEN 1<<4 -- in "origin" and "local" modes
                WHEN 'D' THEN 2<<4 -- disabled
                WHEN 'R' THEN 3<<4 -- in "replica" mode
                WHEN 'A' THEN 4<<4 -- always.
                ELSE 0
              END
            )
      )::INT2 AS info
    , trigger_.tgnargs AS n_args -- int2, number of args for trigger fn
    , trigger_.tgattr AS col_numbers
      -- int2vector (references pg_attribute.attnum)
      -- Column numbers, if trigger is column-specific; otherwise an empty array
  -- references
    , trigger_.tgconstrrelid AS referential_integrity_constraint_table_oid -- can be zero
      -- The table referenced by a referential integrity constraint
    , trigger_.tgconstraint AS constraint_oid
      -- The pg_constraint entry associated with the trigger (zero if trigger is
      -- not for a constraint)
    , trigger_.tgconstrindid AS constraint_index_oid -- can be zero
      -- The index supporting a unique, primary key, referential integrity, or
      -- exclusion constraint
    , trigger_.tgargs AS args -- bytea
      -- Argument strings to pass to trigger, each NULL-terminated
    , trigger_.tgoldtable AS old_table_name -- in REFERENCING clause, if any
    , trigger_.tgnewtable AS new_table_name -- in REFERENCING clause, if any
    , pg_catalog.pg_get_triggerdef(trigger_.oid, true) AS trigger_def
    , pg_catalog.obj_description(trigger_.oid, 'pg_trigger') AS "comment"
FROM pg_catalog.pg_trigger AS trigger_ -- https://www.postgresql.org/docs/current/catalog-pg-trigger.html

