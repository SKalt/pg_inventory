SELECT
    ns.nspname AS schema_name
  , ext.extname AS "name"
  , pg_catalog.pg_get_userbyid(ext.extowner) AS owner_name
  , ext.extversion AS extension_version
  , ext.extrelocatable AS can_be_moved_between_schemata
    -- TODO: map extconfig AS config_table_oids to stable names
  , ext.extcondition AS config_table_filters
    -- Array of WHERE-clause filter conditions for the extension's configuration
    -- table(s), or NULL if none
  , pg_catalog.obj_description(ext.oid, 'pg_extension') AS "comment"
FROM pg_catalog.pg_extension AS ext -- https://www.postgresql.org/docs/current/catalog-pg-extension.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON ext.extnamespace = ns.oid
