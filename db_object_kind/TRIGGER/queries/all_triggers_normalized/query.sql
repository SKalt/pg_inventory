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
    , trigger_.tgisinternal AS is_internal
      -- if trigger is internally generated (usually, to enforce the constraint
      -- identified by tgconstraint)
    , trigger_.tgdeferrable AS is_deferrable
    , trigger_.tginitdeferred AS intially_deferred -- constraint-trigger only
    , trigger_.tgenabled AS session_replication_role_firing_mode
      -- Controls in which session_replication_role modes the trigger fires.
      --  'O' => in "origin" and "local" modes
      --  'D' => disabled
      --  'R' => in "replica" mode
      --  'A' => always.
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
FROM pg_catalog.pg_trigger AS trigger_ -- https://www.postgresql.org/docs/current/catalog-pg-trigger.html

