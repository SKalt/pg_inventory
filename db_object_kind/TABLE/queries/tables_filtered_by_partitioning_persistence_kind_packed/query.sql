SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , cls.relnamespace AS schema_oid
    , cls.relname AS name
    , cls.oid
    , cls_space.spcname AS tablespace_name
    , cls.reltablespace AS tablespace_oid
    , cls.relfilenode AS file_node_oid
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    , cls.relowner AS owner_oid
    , cls.relacl AS acl -- aclitem[]
  -- access method details
    -- TODO: fetch access method name, etc.
    , cls.relam AS access_method_oid
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (zero occurs for sequences, as well as
      --  relations without storage, such as views)
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
  -- details
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "description" -- comment?
    , (-- info: 2-byte int
       -- 0000 0001 1111 1111 : bools
       -- 0000 1110 0000 0000 : replica identity
        0
        | (CASE WHEN cls.relhasindex         THEN 1<<0 ELSE 0 END)
        | (CASE WHEN cls.relisshared         THEN 1<<1 ELSE 0 END)
        | (CASE WHEN cls.relhasrules         THEN 1<<2 ELSE 0 END)
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
      )::INT2 AS info
    , cls.reltype AS type_oid -- references pg_type.oid
      -- The OID of the data type that corresponds to this table's row type, if
      -- any; zero for TOAST tables, which have no pg_type entry
      -- type name, schema, type owner should be the same as the table's.
    , cls.reloftype AS underlying_composite_type_oid
      -- For typed tables, the OID of the underlying composite type; zero for all
      -- other relations
      -- Q: does this apply to partitioned tables?
    -- TODO: split out query identifying typed tables
    , underlying_composite_type.typname AS underlying_composite_type_name
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
        WHEN 'r' THEN true -- ordinary
        WHEN 'p' THEN true -- partitioned
        ELSE (1/0)::BOOLEAN -- error: parameter kind must be either 'r' or 'p'
      END
    ) AND
    cls.relkind = :'kind' AND
    ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    ) AND
    cls.relpersistence = :'persistence' AND
    cls.relispartition = :partitioning AND
    cls.relnamespace = ns.oid
LEFT JOIN pg_tablespace AS cls_space ON (cls.reltablespace = cls_space.oid)
  -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (cls.reloftype = underlying_composite_type.oid)
