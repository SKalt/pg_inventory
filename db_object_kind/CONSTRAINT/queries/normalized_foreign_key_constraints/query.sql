SELECT
  -- constraint namespacing
    constraint_.oid
    , constraint_.connamespace AS schema_oid
    , constraint_.conname AS "name"
  -- constraint enforcement info
    , constraint_.condeferrable AS is_deferrable
    , constraint_.condeferred AS is_deferred_by_default
    , constraint_.convalidated AS is_validated
      -- currently falsifiable only for fk and check
    , constraint_.conislocal AS is_local
      -- the constraint is defined within the relation (can be inherited, too)
    , constraint_.connoinherit AS not_inheritable
      -- not inheritabe AND local to the relation
  -- FK update codes
   , constraint_.confupdtype AS fk_update_action_code
      -- fk update action code:
      -- a => no action
      -- r => restrict
      -- c => cascade
      -- n => set null
      -- d => set default
    , constraint_.confdeltype AS fk_delete_action_code -- same codes as fk update
    , constraint_.confmatchtype AS fk_match_type
      -- f => full
      -- p => partial
      -- s => simple
  -- table constraint information
    , constraint_.conrelid AS relation_oid
      -- always 0 for non-table constraints
      -- if this is a constraint on a partition, the constraint of the
      -- parent partitioned table.
    , pg_get_constraintdef(constraint_.oid, true) AS constraint_def
  -- domain information -- omitted for fks
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
  WHERE constraint_.contype = 'f'
    -- c => check
    -- f => foreign key
    -- p => primary key
    -- t => constraint trigger
    -- u => unique
    -- x => exclusion
) AS constraint_
