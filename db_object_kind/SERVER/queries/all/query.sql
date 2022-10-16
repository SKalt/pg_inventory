SELECT
    srv.oid
  , srv.srvname AS "name"
  , pg_catalog.pg_get_userbyid(srv.srvowner) AS owner_name
  , fdw.fdwname AS fdw
  , srv.srvtype AS server_type -- text | null
  , srv.srvversion AS server_version -- text | null
  , srv.srvacl AS access_privileges
  , srv.srvoptions
    -- Foreign server specific options, as "keyword=value" strings
FROM pg_catalog.pg_foreign_server AS srv
LEFT JOIN pg_catalog.pg_foreign_data_wrapper AS fdw
  ON srv.srvfdw = fdw.oid
