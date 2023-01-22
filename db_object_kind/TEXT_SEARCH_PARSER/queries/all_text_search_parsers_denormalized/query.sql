SELECT
    ( -- fetch schema name: exactly 1 match expected
      SELECT ns.nspname
      FROM pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
      WHERE parser.prsnamespace = ns.oid
    ) AS schema_name
    , parser.prsname AS name
    , ( -- startup_fn_schema
        SELECT nspname
        FROM pg_catalog.pg_namespace AS ns
        WHERE ns.oid = (
          SELECT oid
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsstart::OID
        )
      ) AS startup_fn_schema
    , ( -- startup_fn_name
        SELECT proname
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsstart::OID
      ) AS startup_fn_name
    , ( -- next_token_fn_schema
        SELECT nspname
        FROM pg_catalog.pg_namespace AS ns
        WHERE ns.oid = (
          SELECT oid
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prstoken::OID
        )
      ) AS next_token_fn
    , ( -- next_token_fn_name
        SELECT proname
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prstoken::OID
      ) AS next_token_fn
    , ( -- shutdown_fn_schema
        SELECT nspname
        FROM pg_catalog.pg_namespace AS ns
        WHERE ns.oid = (
          SELECT oid
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsend::OID
        )
      ) AS shutdown_fn_schema
    , ( -- shutdown_fn_name
        SELECT proname
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsend::OID
      ) AS shutdown_fn_name
    , ( -- headline_fn_schema
        SELECT nspname
        FROM pg_catalog.pg_namespace AS ns
        WHERE ns.oid = (
          SELECT oid
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsheadline::OID
        )
      ) AS headline_fn_schema
    , ( -- headline_fn_name
        SELECT proname
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prsheadline::OID
      ) AS headline_fn_name
    , ( -- lextype_fn_schema
        SELECT nspname
        FROM pg_catalog.pg_namespace AS ns
        WHERE ns.oid = (
          SELECT oid
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prslextype::OID
        )
      ) AS lextype_fn_schema
    , ( -- lextype_fn_name
        SELECT proname
          FROM pg_catalog.pg_proc AS fn
          WHERE fn.oid = parser.prslextype::OID
      ) AS lextype_fn_name
    , pg_catalog.obj_description(parser.oid, 'pg_ts_parser') AS "comment"
FROM pg_catalog.pg_ts_parser AS parser -- https://www.postgresql.org/docs/current/catalog-pg-ts-parser.html
