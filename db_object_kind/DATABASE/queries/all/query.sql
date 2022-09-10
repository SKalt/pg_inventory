SELECT
    db.oid
      --  oid     Row identifier
  , db.datname AS db_name
    --  name     Database name
  , admin.oid AS admin_role_oid
  , admin.rolname AS admin_role_name
  , pg_encoding_to_char(db.encoding) AS character_encoding_name
  , db.datcollate AS lc_collate -- name
  , db.datctype AS lc_ctype -- name
  , db.datistemplate AS is_template -- bool
  , db.datallowconn AS allow_connections -- bool
  , db.datconnlimit AS connection_count_limit
  , db.datlastsysoid AS last_system_oid
  , db.datfrozenxid AS min_unfrozen_xid
  , db.datminmxid AS min_multixact_id
  , db.dattablespace AS tablespace_oid
  , db.datacl AS access_privileges
    -- aclitem[]: Access privileges
FROM pg_database AS db
JOIN pg_authid AS admin ON db.datdba = admin.oid
