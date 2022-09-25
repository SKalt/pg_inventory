-- $1: table kind, 'r' or 'p'
-- $2: table persistence, 'p', 'u', or 't'
SELECT
    tbl.oid
  , tbl.relname AS table_name
  , tbl_space.spcname AS tablespace_name
  , tbl.reltablespace AS tablespace_oid
  , tbl.reloptions AS access_method_options
    -- Access-method-specific options, as "keyword=value" strings
  , obj_description(tbl.oid, 'pg_class') AS "description" -- ?
  , pg_get_userbyid(tbl.relowner) AS "owner"
  , tbl.relowner AS owner_oid
  , tbl.relpersistence AS persistence
    -- p = permanent table
    -- u = unlogged table: not dropped at a session
    -- t = temporary table: unlogged **and** dropped at the end of a session.
  , tbl.relacl AS acl -- aclitem[]
  , tbl.relreplident AS replica_identity-- char
    -- Columns used to form "replica identity" for rows:
    -- d = default (primary key, if any),
    -- n = nothing,
    -- f = all columns,
    -- i = index with indisreplident set (same as nothing if the index used has been dropped)
  , tbl.reloftype AS underlying_composite_type_oid
    -- For typed tables, the OID of the underlying composite type; zero for all
    -- other relations
    -- Q: does this apply to partitioned tables?
  -- TODO: split out query identifying typed tables
  , underlying_composite_type.typname AS underlying_composite_type_name
  , tbl.reltuples AS approximate_number_of_rows
FROM pg_catalog.pg_class AS tbl
  -- https://www.postgresql.org/docs/current/catalog-pg-class.html
LEFT JOIN pg_tablespace AS tbl_space ON (tbl.reltablespace = tbl_space.oid)
    -- https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (tbl.reloftype = underlying_composite_type.oid)
WHERE
  tbl.relkind = :'table_kind'
    -- 'r': ordinary
    -- 'p': partitioned
  AND NOT tbl.relispartition
  AND tbl.relpersistence = :'table_persistence'
    -- 'p' = permanent table
    -- 'u' = unlogged table: not dropped at a session
    -- 't' = temporary table: unlogged **and** dropped at the end of a session.