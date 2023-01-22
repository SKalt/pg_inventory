SELECT
    srv.oid
  , srv.srvname AS "name"
  , srv.srvowner AS owner_oid
  , srv.srvfdw AS fdw_oid
  , srv.srvtype AS server_type -- text | null
  , srv.srvversion AS server_version -- text | null
  , srv.srvacl AS access_privileges
  , srv.srvoptions AS options
    -- Foreign server specific options, as "keyword=value" strings
  , pg_catalog.obj_description(srv.oid, 'pg_foreign_server') AS "comment"
FROM pg_catalog.pg_foreign_server AS srv -- https://www.postgresql.org/docs/current/catalog-pg-foreign-server.html
