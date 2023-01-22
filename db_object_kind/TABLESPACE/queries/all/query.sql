SELECT
    tablespace.spcname AS name
  , pg_catalog.pg_get_userbyid(tablespace.spcowner) AS owner_name
  , pg_catalog.pg_tablespace_location(oid) AS "location"
  , tablespace.spcacl AS access_privileges
  , tablespace.spcoptions AS options -- keyword=value strings
  , pg_catalog.shobj_description(tablespace.oid, 'pg_table') AS "comment"
FROM pg_catalog.pg_tablespace AS tablespace -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
