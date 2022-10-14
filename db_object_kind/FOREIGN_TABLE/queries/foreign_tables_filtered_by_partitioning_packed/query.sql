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
  -- access method details -- omitted for classes other than tables and indices
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
    , cls.reltype AS type_oid -- references pg_type.oid
      -- The OID of the data type that corresponds to this table's row type, if
      -- any; zero for TOAST tables, which have no pg_type entry
      -- type name, schema, type owner should be the same as the table's.
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
    cls.relispartition = :partitioning AND
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