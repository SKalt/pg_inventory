SELECT
    rolname AS name
  , rolsuper       AS is_superuser
  , rolinherit     AS inherits_permissions
  , rolcreaterole  AS can_create_roles
  , rolcreatedb    AS can_create_dbs
  , rolcanlogin    AS can_log_in
  , rolreplication AS is_replication_role
  , rolbypassrls   AS bypass_rls

  , rolvaliduntil AS password_expiry_time
  , rolconnlimit  AS connection_count_limit
  , rolconfig     AS runtime_config_var_defaults
FROM pg_catalog.pg_roles -- https://www.postgresql.org/docs/current/view-pg-roles.html
-- see also: https://www.postgresql.org/docs/current/catalog-pg-authid.html
