SELECT
    ns.nspname AS schema_name
  , tbl.relname AS table_name
  , policy_.polname AS policy_name
  , policy_.polcmd AS policy_cmd_type
    -- 'r' => SELECT
    -- 'a' => INSERT
    -- 'w' => UPDATE
    -- 'd' => DELETE
    -- '*' => all
  , policy_.polpermissive AS is_permissinve
  , ARRAY(
      SELECT pg_authid.rolname
      FROM pg_authid
      WHERE pg_authid.oid = ANY(policy_.polroles)
      ORDER BY pg_authid.rolname
    ) AS roles
  , pg_catalog.pg_get_expr(policy_.polqual, policy_.polrelid) AS security_barrier_qualifications
  , pg_catalog.pg_get_expr(policy_.polwithcheck, policy_.polrelid) AS with_check_qualifications
  , pg_catalog.obj_description(policy_.oid, 'pg_policy') AS "comment"
FROM pg_catalog.pg_policy AS policy_ -- https://www.postgresql.org/docs/current/catalog-pg-policy.html
INNER JOIN pg_catalog.pg_class AS tbl ON policy_.polrelid = tbl.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON tbl.relnamespace = ns.oid
