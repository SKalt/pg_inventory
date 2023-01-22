SELECT
  {{- if .oid }}
  oid
  , r.ev_class AS table_oid
  {{- else }}
  ns.nspname AS schema_name
  , cls.relname AS relation
  {{- end }}
  , r.rulename AS name
  {{- if .packed }}
  , ( -- info: int2
      0
      -- 0000 0000 0000 0001 : is_instead
        | CASE WHEN r.is_instead THEN 1<<0 ELSE 0 END
      -- 0000 0000 0000 1110 : event_type
        | ((CASE r.ev_type
            WHEN '1' THEN 1 -- select
            WHEN '2' THEN 2 -- update
            WHEN '3' THEN 3 -- insert
            WHEN '4' THEN 4 -- delete
          END)<<1)
      -- 0000 0000 0111  0000 : session_replication_roles
        | ((CASE r.ev_enabled
            WHEN 'O' THEN 1 -- origin, local modes
            WHEN 'D' THEN 2 -- disabled
            WHEN 'R' THEN 3 -- "replica" mode
            WHEN 'A' THEN 4 -- rule always fires
          END)<<4)
    )::INT2 AS info
  {{- else }}
  , r.is_instead
  , r.ev_type AS event_type
    -- '1' => select
    -- '2' => update
    -- '3' => insert
    -- '4' => delete
  , r.ev_enabled AS session_replication_roles
    -- 'O' => origin, local modes
    -- 'D' => disabled
    -- 'R' => "replica" mode
    -- 'A' => rule always fires
  {{- end }}
  , pg_catalog.pg_get_ruledef(r.oid) AS definition
  , pg_catalog.obj_description(r.oid, 'pg_rewrite') AS "comment"
FROM pg_catalog.pg_rewrite AS r -- https://www.postgresql.org/docs/current/catalog-pg-rewrite.html
{{- if not .oid }}
INNER JOIN pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON ev_class = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
{{- end }}