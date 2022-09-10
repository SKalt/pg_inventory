SELECT
    oid AS role_oid
    -- oid (references pg_authid.oid) ID of role
  , rolname AS name
  , (
      CAST(0 AS SMALLINT)
      | CASE WHEN rolsuper       THEN 1<<8 ELSE 0 END
      | CASE WHEN rolinherit     THEN 1<<7 ELSE 0 END
      | CASE WHEN rolcreaterole  THEN 1<<6 ELSE 0 END
      | CASE WHEN rolcreatedb    THEN 1<<5 ELSE 0 END
      | CASE WHEN rolcanlogin    THEN 1<<4 ELSE 0 END
      | CASE WHEN rolreplication THEN 1<<3 ELSE 0 END
      | CASE WHEN rolbypassrls   THEN 1<<2 ELSE 0 END
  ) AS permission_bits -- int2
  , rolconnlimit AS connection_count_limit
    -- int4: For roles that can log in, this sets maximum number of concurrent connections this role can make. -1 means no limit.
  , rolvaliduntil AS password_expiry_time
    -- timestamptz: Password expiry time (only used for password authentication); null if no expiration
  , rolconfig AS config
    -- text[]: Role-specific defaults for run-time configuration variables
FROM pg_catalog.pg_roles -- https://www.postgresql.org/docs/current/view-pg-roles.html
-- see also: https://www.postgresql.org/docs/current/catalog-pg-authid.html
-- could ORDER BY oid or name here

-- before 9.4, there was rolecatupdate, the ability to mutate the system catalog directly
-- but we only support