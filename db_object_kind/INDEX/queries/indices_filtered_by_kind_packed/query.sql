SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , cls.relname AS name
    , cls_space.spcname AS tablespace_name
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    , cls.relacl AS acl -- aclitem[]
  -- access method details
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (sequences, as well as
      --  relations without storage, such as views)
    , access_method.amname AS access_method_name
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
  -- details
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "description" -- comment?
    , (-- info: 2-byte int
       -- 0000 0001 1111 1111 : bools
       -- 0000 1110 0000 0000 : replica identity
       -- 0011 0000 0000 0000 : persistence
        0
        
        | (CASE WHEN cls.relhastriggers      THEN 1<<3 ELSE 0 END)
        | (CASE WHEN cls.relhassubclass      THEN 1<<4 ELSE 0 END)
        | (CASE WHEN cls.relrowsecurity      THEN 1<<5 ELSE 0 END)
        | (CASE WHEN cls.relforcerowsecurity THEN 1<<6 ELSE 0 END)
        | (CASE WHEN cls.relispartition      THEN 1<<7 ELSE 0 END)
        | ((
            CASE cls.relreplident
              WHEN 'd' THEN 1 -- default (primary key, if any),
              WHEN 'n' THEN 2 -- nothing,
              WHEN 'f' THEN 3 -- all columns,
              WHEN 'i' THEN 4 -- index with indisreplident set (same as nothing
                              -- if the index used has been dropped)
              ELSE          0
            END
          )<<9)
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
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
    , pg_catalog.pg_get_indexdef(cls.oid) AS index_definition
FROM pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON
    ( -- validate input parameter: kind
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
    ) AND
    cls.relkind = :'kind' AND
    cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (cls.reloftype = underlying_composite_type.oid)
