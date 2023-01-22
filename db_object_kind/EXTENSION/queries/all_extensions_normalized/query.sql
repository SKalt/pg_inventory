SELECT
    ext.oid
  , ext.extnamespace AS schema_oid
  , ext.extname AS "name"
  , ext.extowner AS owner_oid
  , ext.extversion AS extension_version
  , ext.extrelocatable AS can_be_moved_between_schemata
  , ext.extconfig AS config_table_oids -- references pg_catalog.pg_class(oid)
  , ext.extcondition AS config_table_filters
    -- Array of WHERE-clause filter conditions for the extension's configuration
    -- table(s), or NULL if none
  , pg_catalog.obj_description(ext.oid, 'pg_extension') AS "comment"
FROM pg_catalog.pg_extension AS ext -- https://www.postgresql.org/docs/current/catalog-pg-extension.html
