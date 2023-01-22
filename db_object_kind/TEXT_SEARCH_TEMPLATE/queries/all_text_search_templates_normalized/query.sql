SELECT
  tpl.oid
  , tpl.tmplnamespace AS schema_oid
  , tpl.tmplname AS name
  , tpl.tmplinit::OID AS init_fn_oid -- can be zero if no init fn
  , tpl.tmpllexize::OID AS lexize_fn_oid -- OID of the template's lexize function
  , pg_catalog.obj_description(tpl.oid, 'pg_ts_template') AS "comment"
FROM pg_catalog.pg_ts_template AS tpl -- https://www.postgresql.org/docs/current/catalog-pg-ts-template.html
