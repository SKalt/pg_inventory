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
    , cls.relhassubclass AS has_subclass
      -- True if table or index has (or once had) any inheritance children
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
    -- omitted: indices aren't governed by check constraints: , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    -- index-specific information
    , (
        SELECT indexed_table_ns.nspname
        FROM pg_class as indexed_table
        INNER join pg_namespace as indexed_table_ns
          ON indexed_table.relnamespace = indexed_table_ns.oid
        WHERE indexed_table.oid = indrelid
      ) AS indexed_table_schema_name
    , (
        SELECT indexed_table.relname
        FROM pg_class as indexed_table
        INNER join pg_namespace as indexed_table_ns
          ON indexed_table.relnamespace = indexed_table_ns.oid
        WHERE indexed_table.oid = indrelid
      ) AS indexed_table_name
    , idx.indkey AS indexed_column_numbers -- 1-indexed; 0s mean expressions
    , idx.indnkeyatts AS n_key_columns
    , idx.indoption AS per_column_flags
    , idx.indisunique AS is_unique
    , idx.indisprimary AS is_primary_key_index
    , idx.indisexclusion AS is_exclusion
    , idx.indimmediate AS uniqueness_checked_immediately
    , idx.indisclustered AS last_clustered_on_this_index
    , idx.indisvalid AS is_valid
    , idx.indcheckxmin AS check_xmin
    , idx.indisready AS is_ready
    , idx.indislive AS is_live
    , idx.indisreplident AS is_replica_identity
    , pg_catalog.pg_get_indexdef(cls.oid) AS index_definition
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind IN ('i', 'I')
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
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
INNER JOIN pg_catalog.pg_index AS idx -- https://www.postgresql.org/docs/current/catalog-pg-index.html
  ON cls.relkind IN ('i', 'I')
  AND cls.oid = idx.indexrelid
