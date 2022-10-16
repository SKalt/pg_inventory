SELECT
    tablespace.spcname AS name
  , pg_catalog.pg_get_userbyid(tablespace.spcowner) AS owner_name
  , pg_catalog.pg_tablespace_location(oid) AS "location"
  , tablespace.spcacl AS access_privileges
  , tablespace.spcoptions AS options -- keyword=value strings
FROM pg_catalog.pg_tablespace AS tablespace