SELECT
  -- namespacing, ownership
        {{ if .oid -}} op_class.opcnamespace AS schema_oid
        {{- else -}} ns.nspname AS schema_name {{- end }}
      , op_class.opcname AS name
      , {{ if .oid -}} op_class.opcmethod AS access_method_oid
        {{- else -}} access_method.amname AS access_method
        {{- end }}
      , {{ if .oid -}} op_class.opcowner AS owner_oid
        {{- else -}} pg_catalog.pg_get_userbyid(op_class.opcowner) AS owner
        {{- end }}
      , {{ if .oid -}} op_class.opcfamily AS op_family_oid
        {{- else -}} op_family_ns.nspname AS op_family_schema
      , op_family.opfname AS op_family
        {{- end }}
      , {{ if .oid -}} op_class.opcintype AS indexed_type_oid
        {{- else -}} indexed_type_ns.nspname AS indexed_type_schema
      , indexed_type.typname AS indexed_type
        {{- end }}
      , op_class.opcdefault AS is_default_for_indexed_type
      , {{ if .oid -}} (
          CASE op_class.opckeytype
            WHEN 0 THEN op_class.opcintype
            ELSE op_class.opckeytype
          END
        ) AS key_type_oid
        {{- else -}} key_type_ns.nspname AS key_type_schema
      , key_type.typname AS key_type
        {{- end }}
FROM pg_catalog.pg_opclass AS op_class -- https://www.postgresql.org/docs/current/catalog-pg-opclass.html
{{- if not .oid }}
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON op_class.opcnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON access_method.oid = op_class.opcmethod
LEFT JOIN (
  pg_catalog.pg_opfamily AS op_family -- https://www.postgresql.org/docs/current/catalog-pg-opfamily.html
  INNER JOIN pg_catalog.pg_namespace AS op_family_ns
    ON op_family.opfnamespace = op_family_ns.oid
) ON op_class.opcfamily = op_family.oid
LEFT JOIN pg_catalog.pg_type AS indexed_type -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON op_class.opcintype = indexed_type.oid
LEFT JOIN pg_catalog.pg_namespace AS indexed_type_ns
  ON indexed_type.typnamespace = indexed_type_ns.oid
LEFT JOIN pg_catalog.pg_type AS key_type
  ON (
    CASE op_class.opckeytype
      WHEN 0 THEN op_class.opcintype
      ELSE op_class.opckeytype
    END
  ) = op_class.opckeytype
LEFT JOIN pg_catalog.pg_namespace AS key_type_ns
  ON key_type.typnamespace = key_type_ns.oid
{{- end }}
