SELECT
  access_method.amname AS "name"
  , ns.nspname AS handler_fn_schema
  , handler_fn.proname AS handler_fn
  , access_method.amtype AS kind
    -- t = table (including materialized views)
    -- i = index.
  , pg_catalog.obj_description(access_method.oid, 'pg_am') AS "comment"
FROM pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
INNER JOIN pg_catalog.pg_proc AS handler_fn
  ON access_method.amhandler = handler_fn.oid
INNER JOIN pg_catalog.pg_namespace AS ns
  ON handler_fn.pronamespace = ns.oid
