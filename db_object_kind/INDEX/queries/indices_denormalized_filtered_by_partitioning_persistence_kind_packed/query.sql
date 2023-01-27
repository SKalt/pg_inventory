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
      -- 0000 0000 1000 0000 : is_partition
        | (CASE WHEN cls.relispartition      THEN 1<<7 ELSE 0 END)
      -- 0000 0001 0000 0000 : is_populated -- omitted: only for materialized/regular views
      -- 0000 1110 0000 0000 : replica_identity
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
    , idx.indkey AS indexed_column_numbers -- 1-indexed; 0s mean expressions
    , idx.indnkeyatts AS n_key_columns
    , idx.indcollation AS collation_oids
    , idx.indclass AS opclass_oids
    , idx.indoption AS per_column_flags
    , ( -- index_info: a 2-byte packed struct
        0
        -- 0000 0000 0000 0001 : is_unique
          | CASE WHEN idx.indisunique THEN 1<<0 ELSE 0 END
        -- 0000 0000 0000 0100 : is_primary_key_index
          | CASE WHEN idx.indisprimary THEN 1<<2 ELSE 0 END
        -- 0000 0000 0000 1000 : is_exclusion
          | CASE WHEN idx.indisexclusion THEN 1<<3 ELSE 0 END
        -- 0000 0000 0001 0000 : uniqueness_checked_immediately
          | CASE WHEN idx.indimmediate THEN 1<<4 ELSE 0 END
        -- 0000 0000 0010 0000 : last_clustered_on_this_index
          | CASE WHEN idx.indisclustered THEN 1<<5 ELSE 0 END
        -- 0000 0000 0100 0000 : is_valid
          | CASE WHEN idx.indisvalid THEN 1<<6 ELSE 0 END
        -- 0000 0000 1000 0000 : check_xmin
          | CASE WHEN idx.indcheckxmin THEN 1<<7 ELSE 0 END
        -- 0000 0001 0000 0000 : is_ready
          | CASE WHEN idx.indisready THEN 1<<8 ELSE 0 END
        -- 0000 0010 0000 0000 : is_live
          | CASE WHEN idx.indislive THEN 1<<9 ELSE 0 END
        -- 0000 0100 0000 0000 : is_replica_identity
          | CASE WHEN idx.indisreplident THEN 1<<10 ELSE 0 END
      )::INT2 AS index_info
    , pg_catalog.pg_get_indexdef(cls.oid) AS index_definition
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND ( -- validate input parameter: kind
      CASE :'kind'
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
        WHEN 'i' THEN true
        WHEN 'I' THEN true
        ELSE (1/0)::BOOLEAN -- error: parameter kind must be either 'i' or 'I'
      END
    )
    AND cls.relkind = :'kind'
    AND ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    )
    AND cls.relpersistence = :'persistence'
    AND cls.relispartition = :partitioning
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
