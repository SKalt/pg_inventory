SELECT
  -- namespacing, ownership
      ns.nspname AS schema_name
      , op_class.opcname AS "name"
      , access_method.amname AS access_method
      , pg_catalog.pg_get_userbyid(op_class.opcowner) AS owner
      , op_family_ns.nspname AS op_family_schema
      , op_family.opfname AS op_family
      , indexed_type_ns.nspname AS indexed_type_schema
      , indexed_type.typname AS indexed_type
      , op_class.opcdefault AS is_default_for_indexed_type
      , key_type_ns.nspname AS key_type_schema
      , key_type.typname AS key_type
      , pg_catalog.obj_description(op_class.oid, 'pg_opclass') AS "comment"
FROM pg_catalog.pg_opclass AS op_class -- https://www.postgresql.org/docs/current/catalog-pg-opclass.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON op_class.opcnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON access_method.oid = op_class.opcmethod
LEFT JOIN (
  pg_catalog.pg_opfamily AS op_family -- https://www.postgresql.org/docs/current/catalog-pg-opfamily.html
  INNER JOIN pg_catalog.pg_namespace AS op_family_ns
    ON op_family.opfnamespace = op_family_ns.oid
) ON op_class.opcfamily = op_family.oid
LEFT JOIN pg_catalog.pg_type AS indexed_type -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON op_class.opcintype = indexed_type.oid
LEFT JOIN pg_catalog.pg_namespace AS indexed_type_ns
  ON indexed_type.typnamespace = indexed_type_ns.oid
LEFT JOIN pg_catalog.pg_type AS key_type
  ON (
    CASE op_class.opckeytype
      WHEN 0 THEN op_class.opcintype
      ELSE op_class.opckeytype
    END
  ) = op_class.opckeytype
LEFT JOIN pg_catalog.pg_namespace AS key_type_ns
  ON key_type.typnamespace = key_type_ns.oid
