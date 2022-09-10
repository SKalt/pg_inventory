SELECT
    oid AS role_oid
    -- oid (references pg_authid.oid) ID of role
  , rolname AS name
  , rolsuper AS is_superuser
    -- bool: Role has superuser privileges
  , rolinherit AS inherits_permissions
    -- bool: Role automatically inherits privileges of roles it is a member of
  , rolcreaterole AS can_create_roles
    -- bool: Role can create more roles
  , rolcreatedb AS can_create_dbs
    -- bool: Role can create databases
  , rolcanlogin AS can_log_in
    -- bool: Role can log in. That is, this role can be given as the initial session authorization identifier
  , rolreplication AS is_replication_role
    -- bool: Role is a replication role. A replication role can initiate replication connections and create and drop replication slots.
  , rolconnlimit AS connection_count_limit
    -- int4: For roles that can log in, this sets maximum number of concurrent connections this role can make. -1 means no limit.
  , rolvaliduntil AS password_expiry_time
    -- timestamptz: Password expiry time (only used for password authentication); null if no expiration
  , rolbypassrls AS bypass_rls
    -- bool Role bypasses every row-level security policy
  , rolconfig AS config
    -- text[]: Role-specific defaults for run-time configuration variables
FROM pg_roles -- https://www.postgresql.org/docs/current/view-pg-roles.html
-- see also: https://www.postgresql.org/docs/current/catalog-pg-authid.html
-- could ORDER BY oid or name here
