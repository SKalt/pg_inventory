-- $1 : the schema name pattern.
SELECT
    ns.nspname           AS schema_name
  , ns.oid               AS schema_oid
  , schema_owner.rolname AS schema_owner_name
  , ns.nspowner          AS schema_owner_oid
  , ns.nspacl            AS schema_acl
FROM pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
INNER JOIN pg_catalog.pg_authid AS schema_owner -- see https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON
    ns.nspname ILIKE :'schema_name_pattern' AND
    NOT EXISTS ( -- filter out schemata that are managed by extensions
      SELECT 1
      FROM pg_catalog.pg_depend AS dependency
      -- https://www.postgresql.org/docs/current/catalog-pg-depend.html
      WHERE
        ns.oid = dependency.objid
        AND dependency.deptype = 'e'
        -- DEPENDENCY_EXTENSION (e): The dependent object is a member of the
        -- referenced extension (see pg_extension)
      LIMIT 1
    ) AND
    ns.nspowner = schema_owner.oid