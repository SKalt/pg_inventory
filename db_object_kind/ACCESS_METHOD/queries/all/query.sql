SELECT
    access_method.amname AS "name"
  , ns.nspname AS handler_fn_schema
  , handler_fn.proname AS handler_fn
  , access_method.amtype AS kind
    -- t = table (including materialized views)
    -- i = index.
FROM pg_catalog.pg_am AS access_method
INNER JOIN pg_catalog.pg_proc AS handler_fn
  ON access_method.amhandler = handler_fn.oid
INNER JOIN pg_catalog.pg_namespace AS ns
  ON handler_fn.pronamespace = ns.oid
