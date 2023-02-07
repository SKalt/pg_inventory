SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , cls.relname AS "name"
    , cls_space.spcname AS tablespace_name
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    , cls.relacl AS acl -- aclitem[]
  -- access method details
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (sequences, as well as
      --  relations without storage, such as views or foreign tables)
    , access_method.amname AS access_method_name
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
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
    , cls.reltuples AS approximate_number_of_rows
    , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    , cls.relallvisible AS n_pages_all_visible
    , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
      -- ^This **is** populated for indices.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    , pg_catalog.pg_get_viewdef(cls.oid, true) AS view_definition
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind = 'm'
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
