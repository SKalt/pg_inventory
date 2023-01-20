SELECT
  access_method.oid
  , access_method.amname AS "name"
  , access_method.amhandler AS handler_fn_oid
  , access_method.amtype AS kind
    -- t = table (including materialized views)
    -- i = index.
  , pg_catalog.obj_description(access_method.oid, 'pg_am') AS "comment"
FROM pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
