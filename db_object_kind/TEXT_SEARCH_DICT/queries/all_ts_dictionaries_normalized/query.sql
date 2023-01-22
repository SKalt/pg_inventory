SELECT
   dict.oid
  , dict.dictnamespace AS schema_oid
  , dict.dictname AS name
  , dict.dictowner AS owner_oid
  , dict.dicttemplate AS ts_template_oid
  , dict.dictinitoption::TEXT AS template_init_options
  , pg_catalog.obj_description(dict.oid, 'pg_ts_dict') AS "comment"
FROM pg_catalog.pg_ts_dict AS dict -- https://www.postgresql.org/docs/urrent/catalog-pg-ts-dict.html
