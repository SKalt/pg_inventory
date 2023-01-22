SELECT
    user_mapping.oid
  , user_mapping.umuser AS role_oid
  , user_mapping.umserver AS server_oid
  , user_mapping.umoptions AS options
FROM pg_catalog.pg_user_mapping AS user_mapping -- https://www.postgresql.org/docs/current/catalog-pg-user-mapping.html
