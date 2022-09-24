{{- include . "./base.sql.tpl" }}
{{ if .schema_filter -}}
  INNER JOIN pg_catalog.pg_namespace AS ns ON (
    {{ include . "../SCHEMA/exclude_extensions.sql.tpl" | indent 2 }}
    {{- if eq .schema_filter "all_schemata_excluding_internal" }}
      AND {{ include "../SCHEMA/exclude_internal.sql.tpl" }}
    {{- else if eq .schema_filter "all_schemata_excluding_internal_named_like" }}
      AND {{ include "../SCHEMA/exclude_internal.sql.tpl" }}
      AND ns.nspname ILIKE :'schema_name'
    {{- else  if eq .schema_filter "all_schemata_named_like" }}
      AND ns.nspname ILIKE :'schema_name'
    {{- else  if eq .schema_filter "single_schema" }}
      AND ns.nspname = :'schema_name'
    {{- end }}
    AND tbl.relnamespace = ns.schema_oid
  )
{{- end }}
LEFT JOIN pg_tablespace AS tbl_space ON (tbl.reltablespace = tbl_space.oid)
    -- https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (tbl.reloftype = underlying_composite_type.oid)
WHERE
  {{ if .table_kind -}}
    tbl.relkind = '{{ .table_kind }}'
  {{- else -}}
    tbl.relkind in ('r', 'p')
  {{- end }}
    -- 'r': ordinary
    -- 'p': partitioned
  {{ if .partition_filter -}}
    AND {{ .partition_filter }}
  {{- end -}}
  {{ if .persistence -}}
    AND tbl.relpersistence = '{{ .persistence }}'
    -- p = permanent table
    -- u = unlogged table: not dropped at a session
    -- t = temporary table: unlogged **and** dropped at the end of a session.
  {{- end }}
ORDER BY tbl.relname, tbl.relkind
