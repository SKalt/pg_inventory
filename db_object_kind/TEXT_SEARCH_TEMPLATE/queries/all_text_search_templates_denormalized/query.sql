SELECT
  ( -- schema_name
    SELECT ns.nspname
    FROM pg_catalog.pg_namespace AS ns
    WHERE ns.oid = tpl.tmplnamespace
  ) AS schema_name
  , tpl.tmplname AS name
  , (
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns
      WHERE ns.oid = (
        SELECT fn.oid
        FROM pg_catalog.pg_proc AS fn
        WHERE fn.oid = tpl.tmplinit::OID
      )
    ) AS init_fn_schema
  , (
      SELECT fn.proname
      FROM pg_catalog.pg_proc AS fn
      WHERE fn.oid = tpl.tmplinit::OID
    ) AS init_fn_name
  , (
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns
      WHERE ns.oid = (
        SELECT fn.oid
        FROM pg_catalog.pg_proc AS fn
        WHERE fn.oid = tpl.tmpllexize::OID
      )
    ) AS init_fn_schema
  , (
      SELECT fn.proname
      FROM pg_catalog.pg_proc AS fn
      WHERE fn.oid = tpl.tmpllexize::OID
    ) AS lexize_fn_name
  , pg_catalog.obj_description(tpl.oid, 'pg_ts_template') AS "comment"
FROM pg_catalog.pg_ts_template AS tpl -- https://www.postgresql.org/docs/current/catalog-pg-ts-template.html
