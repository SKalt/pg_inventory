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
    , (-- info: 2-byte int
        0
      -- 0000 0000 0000 0001 : has_index -- omitted: table-only
      -- 0000 0000 0000 0010 : is_shared -- omitted: table-only
      -- 0000 0000 0000 0100 : has_rules-- omitted: table-only
      -- 0000 0000 0000 1000 : has_triggers
        | (CASE WHEN cls.relhastriggers      THEN 1<<3 ELSE 0 END)
      -- 0000 0000 0001 0000 : has_subclass
        | (CASE WHEN cls.relhassubclass      THEN 1<<4 ELSE 0 END)
      -- 0000 0000 0010 0000 : has_row_level_security
        | (CASE WHEN cls.relrowsecurity      THEN 1<<5 ELSE 0 END)
      -- 0000 0000 0100 0000 : row_level_security_enforced_on_owner
        | (CASE WHEN cls.relforcerowsecurity THEN 1<<6 ELSE 0 END)
      -- 0000 0000 1000 0000 : row_level_security_enforced_on_owner
        | (CASE WHEN cls.relispartition      THEN 1<<7 ELSE 0 END)
      -- 0000 0001 0000 0000 : is_populated -- omitted: only for materialized/regular views
      -- 0000 1110 0000 0000 : replica identity
        | ((
            CASE cls.relreplident
              WHEN 'd' THEN 1 -- default (primary key, if any)
              WHEN 'n' THEN 2 -- nothing
              WHEN 'f' THEN 3 -- all columns
              WHEN 'i' THEN 4 -- index with indisreplident set (same as nothing
                              -- if the index used has been dropped)
              ELSE          0
            END
          )<<9)
      -- 0011 0000 0000 0000 : persistence
        | ((
            CASE cls.relpersistence
              WHEN 'p' THEN 1
              WHEN 'u' THEN 2
              WHEN 't' THEN 3
              ELSE          0
            END
          )<<11)
      )::INT2 AS info
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
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    , pg_catalog.pg_get_indexdef(cls.oid) AS index_definition
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind IN ('i', 'I')
    AND cls.relispartition = :partitioning
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html