SELECT
  {{- if .oid }}
    conversion_.oid
  , conversion_.connamespace AS schema_oid
  {{- else }}
    ns.nspname AS schema_name
  {{- end }}
  , conversion_.conname AS "name"
  {{- if .oid }}
  , conversion_.conowner AS owner_oid
  {{- else }}
  , pg_catalog.pg_get_userbyid(conversion_.conowner) AS owner_name
  {{- end }}
  , conversion_.conforencoding AS source_encoding_id -- int4
  , conversion_.contoencoding AS dest_encoding_id -- int4
  {{- if .oid }}
  , conversion_.conproc AS fn_oid
  {{- else }}
  , fn_ns.nspname AS fn_schema_name
  , fn.proname AS fn_name
  , pg_catalog.pg_get_userbyid(fn.proowner) AS fn_owner_name
  {{- end }}
  , conversion_.condefault AS is_default -- bool
  , pg_catalog.obj_description(conversion_.oid, 'pg_conversion') AS "comment"
FROM pg_catalog.pg_conversion AS conversion_
{{ if not .oid -}}
INNER JOIN pg_catalog.pg_namespace AS ns ON conversion_.connamespace = ns.oid
INNER JOIN pg_catalog.pg_proc AS fn ON conversion_.conproc = fn.oid
INNER JOIN pg_catalog.pg_namespace AS fn_ns ON fn.pronamespace = fn_ns.oid
{{ end -}}