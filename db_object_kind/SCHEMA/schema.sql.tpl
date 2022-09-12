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
  AND ns.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
{{- end }}
  AND NOT EXISTS ( -- filter out schemata that are managed by extensions
    SELECT 1
    FROM pg_catalog.pg_depend AS dependency
    -- https://www.postgresql.org/docs/current/catalog-pg-depend.html
    WHERE
      ns.oid = dependency.objid
      AND dependency.deptype = 'e'
      -- DEPENDENCY_EXTENSION (e): The dependent object is a member of the
      -- referenced extension (see pg_extension)
    LIMIT 1
  )
