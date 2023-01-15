SELECT
  ns.nspname AS schema_name
  , cls.relname AS relation
  , r.rulename AS name
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
  , pg_catalog.pg_get_ruledef(r.oid) AS definition
FROM pg_catalog.pg_rewrite AS r -- https://www.postgresql.org/docs/current/catalog-pg-rewrite.html
INNER JOIN pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON ev_class = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid