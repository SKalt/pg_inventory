SELECT
      parser.oid
    , parser.prsnamespace AS schema_oid
    , parser.prsname AS name
    , parser.prsstart::OID AS startup_fn_oid
    , parser.prstoken::OID AS next_token_fn
    , parser.prsend::OID AS shutdown_fn_oid
    , parser.prsheadline::OID AS headline_fn_oid -- can be zero
    , parser.prslextype::OID AS lextype_fn_oid
    , pg_catalog.obj_description(parser.oid, 'pg_ts_parser') AS "comment"
FROM pg_catalog.pg_ts_parser AS parser -- https://www.postgresql.org/docs/current/catalog-pg-ts-parser.html
