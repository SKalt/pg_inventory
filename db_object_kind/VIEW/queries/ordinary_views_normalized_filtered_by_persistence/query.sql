SELECT
  -- namespacing and ownership
      cls.oid
    , cls.relnamespace AS schema_oid
    , cls.relname AS "name"
    , cls.reltablespace AS tablespace_oid
    , cls.relowner AS owner_oid
    , cls.relacl AS acl -- aclitem[]
  -- access method details -- omitted for classes other than tables and indices
  -- details
    , cls.relreplident AS replica_identity -- char
      -- Columns used to form "replica identity" for rows:
      -- d = default (primary key, if any)
      -- n = nothing
      -- f = all columns
      -- i = index with indisreplident set (same as nothing if the index used has been dropped)
    , cls.relispopulated AS is_populated
      -- Only false for some materialized views
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
    -- omitted: , cls.reltuples AS approximate_number_of_rows
    -- omitted: , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    -- omitted: , cls.relallvisible AS n_pages_all_visible
    , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    , pg_catalog.pg_get_viewdef(cls.oid, true) AS view_definition
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind IN ('v', 'm')
    AND ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    )
    AND cls.relpersistence = :'persistence'
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html