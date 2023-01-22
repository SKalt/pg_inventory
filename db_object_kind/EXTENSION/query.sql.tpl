SELECT
  {{- if .oid }}
    ext.oid
  , ext.extnamespace AS schema_oid
  {{- else }}
    ns.nspname AS schema_name
  {{- end }}
  , ext.extname AS "name"
  {{- if .oid }}
  , ext.extowner AS owner_oid
  {{- else }}
  , pg_catalog.pg_get_userbyid(ext.extowner) AS owner_name
  {{- end }}
  , ext.extversion AS extension_version
  , ext.extrelocatable AS can_be_moved_between_schemata
  {{- if .oid }}
  , ext.extconfig AS config_table_oids -- references pg_catalog.pg_class(oid)
  {{- else }}
    -- TODO: map extconfig AS config_table_oids to stable names
  {{- end }}
  , ext.extcondition AS config_table_filters
    -- Array of WHERE-clause filter conditions for the extension's configuration
    -- table(s), or NULL if none
  , pg_catalog.obj_description(ext.oid, 'pg_extension') AS "comment"
FROM pg_catalog.pg_extension AS ext -- https://www.postgresql.org/docs/current/catalog-pg-extension.html
{{ if not .oid -}}
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON ext.extnamespace = ns.oid
{{ end -}}