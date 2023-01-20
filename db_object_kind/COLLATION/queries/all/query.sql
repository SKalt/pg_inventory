SELECT
    ns.nspname AS schema_name
  , c.collencoding AS "encoding" -- int4
    -- Encoding in which the collation is applicable, or -1 if it works for any encoding
  , c.collname AS "name" -- unique per namespace and encoding
  , pg_catalog.pg_get_userbyid(c.collowner) AS owner_name
  , c.collprovider
    -- Provider of the collation
    -- 'd' => database default
    -- 'c' => libc
    -- 'i' => icu
  , c.collisdeterministic AS is_deterministic
  , c.collcollate AS lc_collate
  , c.collctype AS lc_ctype
  , c.collversion
  -- Provider-specific version of the collation. This is recorded when the
  -- collation is created and then checked when it is used, to detect changes in
  -- the collation definition that could lead to data corruption.
  , pg_catalog.obj_description(c.oid, 'pg_collation') AS "comment"
FROM pg_catalog.pg_collation as c
INNER JOIN pg_catalog.pg_namespace AS ns
  ON c.collnamespace = ns.oid