SELECT
    srv.srvname AS "name"
  , pg_catalog.pg_get_userbyid(srv.srvowner) AS owner_name
  , (
      SELECT fdw.fdwname -- [0, 1] possible matches
      FROM pg_catalog.pg_foreign_data_wrapper AS fdw -- https://www.postgresql.org/docs/current/catalog-pg-foreign-data-wrapper.html
      WHERE srv.srvfdw = fdw.oid
    ) AS fdw
  , srv.srvtype AS server_type -- text | null
  , srv.srvversion AS server_version -- text | null
  , srv.srvacl AS access_privileges
  , srv.srvoptions AS options
    -- Foreign server specific options, as "keyword=value" strings
  , pg_catalog.obj_description(srv.oid, 'pg_foreign_server') AS "comment"
FROM pg_catalog.pg_foreign_server AS srv -- https://www.postgresql.org/docs/current/catalog-pg-foreign-server.html
