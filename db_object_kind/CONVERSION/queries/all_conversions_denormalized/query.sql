SELECT
    ns.nspname AS schema_name
  , conversion_.conname AS "name"
  , pg_catalog.pg_get_userbyid(conversion_.conowner) AS owner_name
  , conversion_.conforencoding AS source_encoding_id -- int4
  , conversion_.contoencoding AS dest_encoding_id -- int4
  , fn_ns.nspname AS fn_schema_name
  , fn.proname AS fn_name
  , pg_catalog.pg_get_userbyid(fn.proowner) AS fn_owner_name
  , conversion_.condefault AS is_default -- bool
  , pg_catalog.obj_description(conversion_.oid, 'pg_conversion') AS "comment"
FROM pg_catalog.pg_conversion AS conversion_
INNER JOIN pg_catalog.pg_namespace AS ns ON conversion_.connamespace = ns.oid
INNER JOIN pg_catalog.pg_proc AS fn ON conversion_.conproc = fn.oid
INNER JOIN pg_catalog.pg_namespace AS fn_ns ON fn.pronamespace = fn_ns.oid
