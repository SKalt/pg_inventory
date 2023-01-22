SELECT
    policy_.oid
  , policy_.polrelid AS relation_oid
  , policy_.polname AS policy_name
  , policy_.polcmd AS policy_cmd_type
    -- 'r' => SELECT
    -- 'a' => INSERT
    -- 'w' => UPDATE
    -- 'd' => DELETE
    -- '*' => all
  , policy_.polpermissive AS is_permissinve
  , policy_.polroles AS role_oids
  , pg_catalog.pg_get_expr(policy_.polqual, policy_.polrelid) AS security_barrier_qualifications
  , pg_catalog.pg_get_expr(policy_.polwithcheck, policy_.polrelid) AS with_check_qualifications
  , pg_catalog.obj_description(policy_.oid, 'pg_policy') AS "comment"
FROM pg_catalog.pg_policy AS policy_ -- https://www.postgresql.org/docs/current/catalog-pg-policy.html