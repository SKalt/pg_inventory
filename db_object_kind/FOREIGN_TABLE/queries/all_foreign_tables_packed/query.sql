SELECT
  -- namespacing and ownership
      tbl.schema_name
    , tbl.name
    , tbl.tablespace_name
    , tbl.owner
  -- access method details
    , tbl.acl -- aclitem[]
  -- details
    , tbl.description
    , tbl.info
    , tbl.n_pages
    , tbl.n_pages_all_visible
    , tbl.n_user_columns
    , tbl.n_check_constraints
  -- foreign-table specific
    , foreign_table.ftoptions AS foreign_table_options
    , foreign_server.srvname AS server_name
FROM pg_catalog.pg_foreign_table AS foreign_table
INNER JOIN pg_catalog.pg_class AS cls ON foreign_table.ftrelid = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON cls.relnamespace = ns.oid
INNER JOIN (
  SELECT
    -- namespacing and ownership
        ns.nspname AS schema_name
      , cls.relname AS name
      , cls_space.spcname AS tablespace_name
      , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
      , cls.relacl AS acl -- aclitem[]
    -- access method details -- omitted for classes other than tables and indices
    -- details
      , pg_catalog.obj_description(cls.oid, 'pg_class') AS "description" -- comment?
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
        -- 0000 0000 1000 0000 : row_level_security_enforced_on_owner -- omitted: only applicable to tables or indices
        -- 0000 0001 0000 0000 : is_populated -- omitted: only for materialized/regular views
        -- 0000 1110 0000 0000 : replica identity
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
      , cls.relchecks AS n_check_constraints
        -- int2; see pg_constraint catalog
  FROM pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
    ON
      cls.relkind = 'f' AND
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
  
) AS tbl ON ns.nspname = tbl.schema_name AND cls.relname = tbl.name
INNER JOIN pg_catalog.pg_foreign_server AS foreign_server
  ON foreign_table.ftserver = foreign_server.oid