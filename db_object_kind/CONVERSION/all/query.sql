SELECT
    ns.nspname AS schema_name
  , ns.oid AS schema_oid
  , conversion_.conname AS "name"
  , conversion_.oid
  , pg_catalog.pg_get_userbyid(conversion_.conowner) AS owner_name
  , conversion_.conowner AS owner_oid
  , conversion_.conforencoding AS source_encoding_id -- int4
  , conversion_.contoencoding AS dest_encoding_id -- int4
  , fn_ns.nspname AS fn_schema_name
  , fn_ns.oid AS fn_schema_oid
  , fn.proname AS fn_name
  , pg_catalog.pg_get_userbyid(fn.proowner) AS fn_owner_name
  , fn.proowner AS fn_owner_oid
  , conversion_.condefault AS is_default -- bool
FROM pg_catalog.pg_conversion AS conversion_
INNER JOIN pg_catalog.pg_namespace AS ns ON conversion_.connamespace = ns.oid
INNER JOIN pg_catalog.pg_proc AS fn ON conversion_.conproc = fn.oid
INNER JOIN pg_catalog.pg_namespace AS fn_ns ON fn.pronamespace = fn_ns.oid
