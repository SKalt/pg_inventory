SELECT
      fdw.oid
    , fdw.fdwname AS "name"
    , fdw.fdwowner AS owner_oid
    , pg_catalog.pg_get_userbyid(fdw.fdwowner) AS owner_name
    , fdw.fdwacl AS access_privileges
    , fdw.fdwoptions AS options

    , fdw.fdwhandler AS handler_fn_oid
      -- References a handler function that is responsible for supplying
      -- execution routines for the foreign-data wrapper. Zero if no handler
      -- is provided
    , handler_fn.proname AS handler_fn_name
    , handler_fn.pronamespace AS handler_fn_schema_oid
    , handler_fn_ns.nspname AS handler_fn_schema_name
    , pg_catalog.pg_get_userbyid(handler_fn.proowner) AS handler_fn_owner

    , fdw.fdwvalidator AS validator_fn_oid
      -- References a validator function that is responsible for checking the
      -- validity of the options given to the foreign-data wrapper, as well as
      -- options for foreign servers and user mappings using the foreign-data
      -- wrapper. Zero if no validator is provided
    , validator_fn.pronamespace AS validator_fn_schema_oid
    , validator_fn_ns.nspname AS validator_fn_schema_name
    , validator_fn.proname AS validator_fn_name
    , pg_catalog.pg_get_userbyid(validator_fn.proowner) AS validator_fn_owner
FROM pg_catalog.pg_foreign_data_wrapper AS fdw
LEFT JOIN (
    pg_catalog.pg_proc AS handler_fn
    INNER JOIN pg_catalog.pg_namespace AS handler_fn_ns
      ON handler_fn.pronamespace = handler_fn_ns.oid
  )
  ON fdw.fdwhandler > 0 AND fdw.fdwhandler = handler_fn.oid
LEFT JOIN (
    pg_catalog.pg_proc AS validator_fn
    INNER JOIN pg_catalog.pg_namespace AS validator_fn_ns
      ON validator_fn.pronamespace = validator_fn_ns.oid
  )
  ON fdw.fdwvalidator > 0 AND fdw.fdwvalidator = validator_fn.oid