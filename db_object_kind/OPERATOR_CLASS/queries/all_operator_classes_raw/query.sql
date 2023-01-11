SELECT
  -- namespacing, ownership
        op_class.opcnamespace AS schema_oid
      , op_class.opcname AS name
      , op_class.opcmethod AS access_method_oid
      , op_class.opcowner AS owner_oid
      , op_class.opcfamily AS op_family_oid
      , op_class.opcintype AS indexed_type_oid
      , op_class.opcdefault AS is_default_for_indexed_type
      , (
          CASE op_class.opckeytype
            WHEN 0 THEN op_class.opcintype
            ELSE op_class.opckeytype
          END
        ) AS key_type_oid
FROM pg_catalog.pg_opclass AS op_class -- https://www.postgresql.org/docs/current/catalog-pg-opclass.html
