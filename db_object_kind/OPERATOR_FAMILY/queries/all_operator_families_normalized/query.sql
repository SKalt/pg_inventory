SELECT
  -- namespacing and ownership
      opfnamespace AS schema_oid
    , op_family.opfname AS name
    , op_family.oid
    , op_family.opfowner AS owner_oid
  -- details
    , op_family.opfmethod AS access_method_oid
FROM pg_catalog.pg_opfamily AS op_family -- https://www.postgresql.org/docs/current/catalog-pg-opfamily.html
