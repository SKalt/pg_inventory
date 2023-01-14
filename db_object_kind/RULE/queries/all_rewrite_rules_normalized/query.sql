SELECT
  oid
  , ev_class AS table_oid
  , rulename AS name
  , ev_type AS event_type
    -- '1' => select
    -- '2' => update
    -- '3' => insert
    -- '4' => delete
  ,  ev_enabled AS session_replication_roles
    -- 'O' => origin, local modes
    -- 'D' => disabled
    -- 'R' => "replica" mode
    -- 'A' => rule always fires
  , pg_catalog.pg_get_ruledef(r.oid) AS definition
FROM pg_catalog.pg_rewrite AS r -- https://www.postgresql.org/docs/current/catalog-pg-rewrite.html