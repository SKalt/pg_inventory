SELECT
    srv.oid
  , srv.srvname AS "name"
  , srv.srvowner AS owner_oid
  , pg_catalog.pg_get_userbyid(srv.srvowner) AS owner_name
  , srv.srvfdw AS fdw_oid
  /*TODO: fdw info?*/
  , srv.srvtype AS server_type -- text | null
  , srv.srvversion AS server_version -- text | null
  , srv.srvacl AS access_privileges
  , srv.srvoptions
    -- Foreign server specific options, as "keyword=value" strings
FROM pg_catalog.pg_foreign_server AS srv
