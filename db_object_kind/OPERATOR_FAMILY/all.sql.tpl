SELECT
  -- namespacing and ownership
    {{- if .oid }}
      op_family.oid
    , op_family.opfnamespace AS schema_oid
    {{- else }}
      ns.nspname AS schema_name
    {{- end }}
    , op_family.opfname AS name
    {{- if .oid }}
    , op_family.oid
    , op_family.opfowner AS owner_oid
    {{- else }}
    , pg_catalog.pg_get_userbyid(op_family.opfowner) AS owner
    {{- end }}
  -- details
    {{- if .oid }}
    , op_family.opfmethod AS access_method_oid
    {{- else }}
    , access_method.amname AS access_method
    {{- end }}
    , pg_catalog.obj_description(op_family.oid, 'pg_opfamily') AS "comment"
FROM pg_catalog.pg_opfamily AS op_family -- https://www.postgresql.org/docs/current/catalog-pg-opfamily.html
{{- if not .oid }}
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON op_family.opfnamespace = ns.oid
INNER JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON op_family.opfmethod = access_method.oid
{{- end }}
