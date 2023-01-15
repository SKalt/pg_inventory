SELECT
  ns.nspname AS schema_name
  , cls.relname AS relation
  , r.rulename AS name
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
  , pg_catalog.pg_get_ruledef(r.oid) AS definition
FROM pg_catalog.pg_rewrite AS r -- https://www.postgresql.org/docs/current/catalog-pg-rewrite.html
INNER JOIN pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON ev_class = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid