SELECT
  {{- if .oid }}
    user_mapping.oid
  , user_mapping.umuser AS role_oid
  , user_mapping.umserver AS server_oid
  {{- else }}
    pg_catalog.pg_get_userbyid(umuser) AS role_name
  , ( -- server_name
      select srvname
      from pg_catalog.pg_foreign_server AS srv
      where srv.oid = user_mapping.umserver
    ) AS server_name
  {{- end }}
  , user_mapping.umoptions AS options
FROM pg_catalog.pg_user_mapping AS user_mapping -- https://www.postgresql.org/docs/current/catalog-pg-user-mapping.html
