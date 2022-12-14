SELECT
  ext.oid
  , ext.extname AS "name"
  , pg_catalog.pg_get_userbyid(ext.extowner) AS owner_name
  , ext.extnamespace AS schema_oid
  , ns.nspname AS schema_name
  , ext.extrelocatable AS can_be_moved_between_schemata
  , ext.extversion AS extension_version
  , ext.extconfig AS config_table_oids -- references pg_catalog.pg_class(oid)
    -- TODO: map config_table_oids to stable names
  , ext.extcondition AS config_table_filters
    -- Array of WHERE-clause filter conditions for the extension's configuration
    -- table(s), or NULL if none
FROM pg_catalog.pg_extension AS ext -- https://www.postgresql.org/docs/current/catalog-pg-extension.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON ext.extnamespace = ns.oid
