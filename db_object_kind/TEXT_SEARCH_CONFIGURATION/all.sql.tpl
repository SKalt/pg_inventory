SELECT
    {{ if .oid -}} cfg.oid
  , cfg.cfgnamespace AS schema_oid
  {{- else -}}
    ( -- fetch schema name: exactly 1 match expected
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
      WHERE cfg.cfgnamespace = ns.oid
    ) AS schema_name
  {{- end }}
  , cfg.cfgname AS "name"
  {{- if .oid }}
  , cfg.cfgowner AS owner_oid
  , cfg.cfgparser AS ts_parser_oid
  {{- else }}
  , pg_catalog.pg_get_userbyid(cfg.cfgowner) AS owner
  , ( -- ts_parser_schema
      SELECT nspname
      FROM pg_catalog.pg_namespace AS ns
      WHERE ns.oid = (
        SELECT parser.prsnamespace
        FROM pg_catalog.pg_ts_parser AS parser
        WHERE cfg.cfgparser = parser.oid
      )
    ) AS ts_parser_schema
  , ( -- ts_parser_name
      SELECT parser.prsname
      FROM pg_catalog.pg_ts_parser AS parser
      WHERE cfg.cfgparser = parser.oid
    ) AS ts_parser_name
  {{- end }}
  , pg_catalog.obj_description(cfg.oid, 'pg_ts_config') AS "comment"
FROM pg_catalog.pg_ts_config AS cfg -- https://www.postgresql.org/docs/current/catalog-pg-ts-config.html
