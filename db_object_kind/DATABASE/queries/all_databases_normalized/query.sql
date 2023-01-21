SELECT
    db.datname AS "name"
  , db.datdba AS admin_role_oid
  , pg_encoding_to_char(db.encoding) AS character_encoding_name
  , db.datcollate AS lc_collate -- name
  , db.datctype AS lc_ctype -- name
  , db.datistemplate AS is_template -- bool
  , db.datallowconn AS allow_connections -- bool
  , db.datconnlimit AS connection_count_limit
  , db.datacl AS access_privileges -- aclitem[]
  -- , db.datfrozenxid AS min_unfrozen_xid
  -- , db.datminmxid AS min_multixact_id
FROM pg_catalog.pg_database AS db -- https://www.postgresql.org/docs/current/catalog-pg-database.html
