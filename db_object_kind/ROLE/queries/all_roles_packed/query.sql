SELECT
    rolname AS name
  , (-- permissions: 2-bit packed integer:
      0
     -- 0000 0000 0000 0001 : is_superuser
      | CASE WHEN rolsuper       THEN 1<<0 ELSE 0 END
     -- 0000 0000 0000 0010 : inherits_permissions
      | CASE WHEN rolinherit     THEN 1<<1 ELSE 0 END
     -- 0000 0000 0000 0100 : can_create_roles
      | CASE WHEN rolcreaterole  THEN 1<<2 ELSE 0 END
     -- 0000 0000 0000 1000 : can_create_dbs
      | CASE WHEN rolcreatedb    THEN 1<<3 ELSE 0 END
     -- 0000 0000 0001 0000 : can_log_in
      | CASE WHEN rolcanlogin    THEN 1<<4 ELSE 0 END
     -- 0000 0000 0010 0000 : is_replication_role
      | CASE WHEN rolreplication THEN 1<<5 ELSE 0 END
     -- 0000 0000 0100 0000 : bypass_row_level_security
      | CASE WHEN rolbypassrls   THEN 1<<6 ELSE 0 END
    )::INT2 AS permission_bits
  , rolvaliduntil AS password_expiry_time
  , rolconnlimit  AS connection_count_limit
  , rolconfig     AS runtime_config_var_defaults
  , pg_catalog.shobj_description(oid, 'pg_authid') AS "comment"
FROM pg_catalog.pg_roles -- https://www.postgresql.org/docs/current/view-pg-roles.html
-- see also: https://www.postgresql.org/docs/current/catalog-pg-authid.html
