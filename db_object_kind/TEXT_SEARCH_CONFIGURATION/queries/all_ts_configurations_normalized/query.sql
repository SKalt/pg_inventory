SELECT
    cfg.oid
  , cfg.cfgnamespace AS schema_oid
  , cfg.cfgname AS "name"
  , cfg.cfgowner AS owner_oid
  , cfg.cfgparser AS ts_parser_oid
  , pg_catalog.obj_description(cfg.oid, 'pg_ts_config') AS "comment"
FROM pg_catalog.pg_ts_config AS cfg -- https://www.postgresql.org/docs/current/catalog-pg-ts-config.html
