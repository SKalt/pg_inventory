SELECT
    tablespace.oid
  , tablespace.spcname AS name
  , tablespace.spcowner AS owner_oid
  , pg_catalog.pg_tablespace_location(oid) AS "location"
  , tablespace.spcacl AS access_privileges
  , tablespace.spcoptions AS options -- keyword=value strings
  , pg_catalog.shobj_description(tablespace.oid, 'pg_table') AS "comment"
FROM pg_catalog.pg_tablespace AS tablespace -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
