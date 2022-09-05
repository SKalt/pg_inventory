-- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
{{ printf "-- %+v\n" .ilike}}
SELECT
    oid      AS schema_oid
  , nspname  AS schema_name
  , nspowner AS schema_owner
  , nspacl   AS schema_acl
FROM pg_catalog.pg_namespace AS ns
WHERE
{{- if .ilike }}
  nspname ILIKE :'schema_name'
{{- end }}
-- TODO: figure out how to template a where-clause
{{- if .exclude_internal }}
  ns.nspname NOT IN ('pg_catalog', 'pg_toast', 'information_schema')
{{- end }}
-- TODO: factor this query into a separate file
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
