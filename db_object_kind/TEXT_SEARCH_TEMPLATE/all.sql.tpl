SELECT
  {{- if .oid }}
  tpl.oid
  , tpl.tmplnamespace AS schema_oid
  {{- else }}
  ( -- schema_name
    SELECT ns.nspname
    FROM pg_catalog.pg_namespace AS ns
    WHERE ns.oid = tpl.tmplnamespace
  ) AS schema_name
  {{- end }}
  , tpl.tmplname AS name
  {{- if .oid }}
  , tpl.tmplinit::OID AS init_fn_oid -- can be zero if no init fn
  , tpl.tmpllexize::OID AS lexize_fn_oid -- OID of the template's lexize function
  {{- else }}
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
  {{- end }}
  , pg_catalog.obj_description(tpl.oid, 'pg_ts_template') AS "comment"
FROM pg_catalog.pg_ts_template AS tpl -- https://www.postgresql.org/docs/current/catalog-pg-ts-template.html
