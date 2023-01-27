SELECT
  -- namespacing
    fdw.oid
  , fdw.fdwname AS "name"
  , fdw.fdwowner AS owner_oid
  , fdw.fdwacl AS access_privileges
  , fdw.fdwoptions AS options
  , fdw.fdwhandler AS handler_fn_oid
  , fdw.fdwvalidator AS validator_fn_oid
FROM pg_catalog.pg_foreign_data_wrapper AS fdw -- https://www.postgresql.org/docs/current/catalog-pg-foreign-data-wrapper.html
