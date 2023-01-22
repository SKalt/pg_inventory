SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , op_family.opfname AS name
    , pg_catalog.pg_get_userbyid(op_family.opfowner) AS owner
  -- details
    , access_method.amname AS access_method
FROM pg_catalog.pg_opfamily AS op_family -- https://www.postgresql.org/docs/current/catalog-pg-opfamily.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON op_family.opfnamespace = ns.oid
INNER JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON op_family.opfmethod = access_method.oid
