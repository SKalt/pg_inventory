-- $1 : the schema name {{- if .ilike }} pattern{{ end }}.
SELECT
    ns.nspname           AS schema_name
  , ns.oid               AS schema_oid
  , schema_owner.rolname AS schema_owner_name
  , ns.nspowner          AS schema_owner_oid
  , ns.nspacl            AS schema_acl
FROM pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
INNER JOIN pg_catalog.pg_authid AS schema_owner -- see https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON
  {{- if .ilike }}
    ns.nspname ILIKE :'schema_name_pattern' AND
  {{- end }}
  {{- if .equals }}
    ns.nspname = :'schema_name' AND
  {{- end }}
  {{- if .exclude_internal }}
    {{ include . "./exclude_internal.sql.tpl" }} AND
  {{- end }}
    {{ include . "./exclude_extensions.sql.tpl" | indent 2 }} AND
    ns.nspowner = schema_owner.oid