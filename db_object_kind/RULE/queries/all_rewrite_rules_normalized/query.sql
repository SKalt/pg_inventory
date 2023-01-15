SELECT
  oid
  , r.ev_class AS table_oid
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