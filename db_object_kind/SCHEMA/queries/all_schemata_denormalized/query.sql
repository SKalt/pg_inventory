SELECT
     pg_catalog.pg_get_userbyid(ns.nspowner) AS owner_name
  , ns.nspname           AS "name"
  , ns.nspacl            AS acl
  , pg_catalog.obj_description(ns.oid ,'pg_namespace') AS "comment"
FROM (
  -- filter out extension-owned schemata
  SELECT *
  FROM pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  WHERE NOT EXISTS ( -- filter out schemata that are managed by extensions
      SELECT 1
      FROM pg_catalog.pg_depend AS dependency
      -- https://www.postgresql.org/docs/current/catalog-pg-depend.html
      WHERE
        ns.oid = dependency.objid
        AND dependency.deptype = 'e'
        -- DEPENDENCY_EXTENSION (e): The dependent object is a member of the
        -- referenced extension (see pg_extension)
      LIMIT 1
    )
) AS ns
INNER JOIN pg_catalog.pg_authid AS schema_owner -- see https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON ns.nspowner = schema_owner.oid