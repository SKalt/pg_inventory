SELECT
  -- namespacing and ownership
      cls.oid
    , cls.relnamespace AS schema_oid
    , cls.relname AS "name"
    , cls.reltablespace AS tablespace_oid
    , cls.relowner AS owner_oid
    , cls.relacl AS acl -- aclitem[]
  -- access method details
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (sequences, as well as
      --  relations without storage, such as views or foreign tables)
    , cls.relam AS access_method_oid
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
  -- details
    , cls.relreplident AS replica_identity -- char
      -- Columns used to form "replica identity" for rows:
      -- d = default (primary key, if any)
      -- n = nothing
      -- f = all columns
      -- i = index with indisreplident set (same as nothing if the index used has been dropped)
    , cls.relhasindex AS has_index
      -- True if this is a table and it has (or recently had) any indexes
    , cls.relisshared AS is_shared
      -- whether this table is shared across all databases in the cluster.
      -- Only certain system catalogs (such as pg_database) are shared.
    , cls.relhasrules AS has_rules
      -- True if table has (or once had) rules; see pg_rewrite catalog
    , cls.relhastriggers AS has_triggers
      -- True if table has (or once had) triggers; see pg_trigger catalog
    , cls.relhassubclass AS has_subclass
      -- True if table or index has (or once had) any inheritance children
    , cls.relrowsecurity AS has_row_level_security
      -- True if table has row-level security enabled; see pg_policy catalog
    , cls.relforcerowsecurity AS row_level_security_enforced_on_owner
      -- if row-level security (when enabled) will also apply to table owner; see pg_policy catalog
    , cls.relispartition AS is_partition
    , cls.relpersistence AS persistence
      -- p => permanent table
      -- u => unlogged table: not dropped at a session
      -- t => temporary table: unlogged **and** dropped at the end of a session.
    , cls.relkind AS kind
      -- r => ordinary table
      -- p => partitioned table
      -- i => index
      -- I => partitioned index
      -- S => sequence
      -- t => TOAST table
      -- v => view
      -- m => materialized view
      -- c => composite type
      -- f => foreign table
    , cls.reloftype AS underlying_composite_type_oid
      -- for typed tables
    , cls.reltuples AS approximate_number_of_rows
    , (
        CASE
          WHEN cls.relispartition THEN pg_catalog.pg_get_expr(cls.relpartbound, cls.oid, true)
          ELSE NULL
        END
      ) AS partition_bound
    , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    , cls.relallvisible AS n_pages_all_visible
    , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
      -- ^This **is** populated for indices.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind IN ('r', 'p')
    AND cls.relispartition = :partitioning
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
