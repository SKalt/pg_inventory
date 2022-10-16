SELECT
    user_mapping.umid AS oid
  , user_mapping.srvname AS server_name
  , user_mapping.usename AS user_name
  , user_mapping.umoptions AS options
FROM pg_catalog.pg_user_mappings AS user_mapping
