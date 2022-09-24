-- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
SELECT
    oid      AS schema_oid
  , nspname  AS schema_name
  , nspowner AS schema_owner_oid
    -- TODO: join to get owner names?
  , nspacl   AS schema_acl
FROM pg_catalog.pg_namespace AS ns
WHERE 1=1
{{- if .ilike }}
  AND nspname ILIKE :'schema_name'
{{- end }}
{{- if .exclude_internal }}
  AND {{ include . "./exclude_internal.sql.tpl" }}
{{- end }}
  AND {{ include . "./exclude_extensions.sql.tpl" | indent 1 }}