SELECT
  oid
  , ev_class AS table_oid
  , rulename AS name
  , ( -- info: int2
      0
      -- 0000 0000 0000 0001 : is_instead
        | CASE WHEN is_instead THEN 1<<0 ELSE 0 END
      -- 0000 0000 0000 1110 : event_type
        | (CASE ev_type
            WHEN '1' THEN 1<<1 -- select
            WHEN '2' THEN 2<<1 -- update
            WHEN '3' THEN 3<<1 -- insert
            WHEN '4' THEN 4<<1 -- delete
          END)
      -- 0000 0000 0111  0000 : session_replication_roles
        | ((CASE ev_enabled
            WHEN 'O' THEN 1 -- origin, local modes
            WHEN 'D' THEN 2 -- disabled
            WHEN 'R' THEN 3 -- "replica" mode
            WHEN 'A' THEN 4 -- rule always fires
          END)<<4)
    )::INT2 AS info
  , pg_catalog.pg_get_ruledef(r.oid) AS definition
FROM pg_catalog.pg_rewrite AS r -- https://www.postgresql.org/docs/current/catalog-pg-rewrite.html