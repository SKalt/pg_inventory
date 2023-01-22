SELECT
  {{ if .oid }} dict.oid
  , dict.dictnamespace AS schema_oid
  {{- else -}}
    ( -- schema_name
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns
      WHERE dict.dictnamespace = ns.oid
    ) AS schema_name
  {{- end }}
  , dict.dictname AS name

  {{- if .oid }}
  , dict.dictowner AS owner_oid
  {{- else }}
  , pg_catalog.pg_get_userbyid(dict.dictowner) AS owner
  {{- end }}

  {{- if .oid }}
  , dict.dicttemplate AS ts_template_oid
  {{- else }}
  , ( -- ts_template_schema
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns
      WHERE ns.oid = (
        SELECT tpl.oid
        FROM pg_catalog.pg_ts_template AS tpl -- https://www.postgresql.org/docs/current/catalog-pg-ts-template.html
        WHERE tpl.oid = dict.dicttemplate
      )
    )  AS ts_template_schema
  , ( -- ts_template_name
      SELECT tpl.tmplname
      FROM pg_catalog.pg_ts_template AS tpl
      WHERE tpl.oid = dict.dicttemplate
    ) AS ts_template_name
  {{- end }}
  , dict.dictinitoption::TEXT AS template_init_options
  , pg_catalog.obj_description(dict.oid, 'pg_ts_dict') AS "comment"
FROM pg_catalog.pg_ts_dict AS dict -- https://www.postgresql.org/docs/urrent/catalog-pg-ts-dict.html
