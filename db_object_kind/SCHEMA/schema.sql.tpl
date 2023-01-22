SELECT
  {{- if .oid }}
    ns.oid
  , ns.nspowner AS owner_oid
  {{- else }}
     pg_catalog.pg_get_userbyid(ns.nspowner) AS owner_name
  {{- end }}
  , ns.nspname           AS "name"
  , ns.nspacl            AS acl
  , pg_catalog.obj_description(ns.oid ,'pg_namespace') AS "comment"
FROM (
  -- filter out extension-owned schemata
  SELECT *
  FROM pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  WHERE {{ include . "./exclude_extensions.sql.tpl" | indent 2 }}
) AS ns
{{- if not .oid }}
INNER JOIN pg_catalog.pg_authid AS schema_owner -- see https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON ns.nspowner = schema_owner.oid
{{- end }}