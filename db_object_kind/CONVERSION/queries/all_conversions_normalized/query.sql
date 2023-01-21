SELECT
    conversion_.oid
  , conversion_.connamespace AS schema_oid
  , conversion_.conname AS "name"
  , conversion_.conowner AS owner_oid
  , conversion_.conforencoding AS source_encoding_id -- int4
  , conversion_.contoencoding AS dest_encoding_id -- int4
  , conversion_.conproc AS fn_oid
  , conversion_.condefault AS is_default -- bool
  , pg_catalog.obj_description(conversion_.oid, 'pg_conversion') AS "comment"
FROM pg_catalog.pg_conversion AS conversion_
