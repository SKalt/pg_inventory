SELECT
  -- namespacing
      ns.nspname AS schema_name
    , ns.oid AS schema_oid
    , tbl.relname AS table_name
    , trigger_.tgrelid AS table_oid
    , trigger_.oid
    , trigger_.tgname AS "name" -- must be unique among triggers of same table
    , trigger_.tgparentid AS parent_trigger_oid
      -- Parent trigger that this trigger is cloned from (this happens when
      -- partitions are created or attached to a partitioned table); zero if not
      -- a clone
    , trigger_.tgfoid AS handler_fn_oid
    -- TODO: proname, pronamespace
    , trigger_.tgtype -- int2 bitmask identifying trigger firing conditions
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
  , trigger_.tgattr
    -- int2vector (references pg_attribute.attnum)
    -- Column numbers, if trigger is column-specific; otherwise an empty array
  , trigger_.tgconstrrelid AS referenced_table_oid
    -- The table referenced by a referential integrity constraint (zero if
    -- trigger is not for a referential integrity constraint)
  , ref.relname AS referenced_table_name
    -- TODO: referenced_table_schema_name
  , constraint_.conname AS constraint_name
  , trigger_.tgconstraint AS constraint_oid
    -- The pg_constraint entry associated with the trigger (zero if trigger is
    -- not for a constraint)
  -- TODO: constraint_schema_name
  , trigger_.tgconstrindid
    -- The index supporting a unique, primary key, referential integrity, or
    -- exclusion constraint (zero if trigger is not for one of these types of
    --  constraint)
  , trigger_.tgargs AS args -- bytea
    -- Argument strings to pass to trigger, each NULL-terminated
  , trigger_.tgoldtable AS old_table_name -- in REFERENCING clause, if any
  , trigger_.tgnewtable AS old_table_name -- in REFERENCING clause, if any
  , pg_catalog.pg_get_expr(trigger_.tgqual, tbl.oid) AS trigger_when_clause
FROM pg_catalog.pg_trigger AS trigger_
INNER JOIN pg_catalog.pg_class AS tbl
  ON trigger_.tgrelid = tbl.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON tbl.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_class AS ref ON trigger_.tgconstrrelid = ref.oid
LEFT JOIN pg_catalog.pg_constraint AS constraint_ ON
  trigger_.tgconstraint > 0 AND trigger_.tgconstraint = constraint_.oid