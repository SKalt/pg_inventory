SELECT
  ext.oid
  , ext.extname AS "name"
  , ext.extowner AS owner_oid
  , pg_catalog.pg_get_userbyid(ext.extowner) AS owner_name
  , ext.extnamespace AS schema_oid
  , ns.nspname AS schema_name
  , ext.extrelocatable AS can_be_moved_between_schemata
  , ext.extversion AS extension_version
  , ext.extconfig AS config_table_oids -- references pg_catalog.pg_class(oid)
  , ext.extcondition AS config_table_filters
    -- Array of WHERE-clause filter conditions for the extension's configuration
    -- table(s), or NULL if none
FROM pg_catalog.pg_extension AS ext
INNER JOIN pg_catalog.pg_namespace AS ns
  ON ext.extnamespace = ns.oid