SELECT
  rel_schema.nspname AS relation_schema
  , rel.relname AS relation
  , col.attnum AS col_number -- int2: 1-indexed
  , col.attname AS col_name
  , type_ns.nspname AS type_schema -- null if the column has been dropped
  , type_.typname AS type_name
  , col.attstattarget AS stats_detail_level -- int4: for ANALYZE
  , col.attndims AS dimension_number -- dimension_number > 0 means array
  , col.atttypmod AS type_length -- int4, for type-specific input and length-coersion, e.g. varchar(n)
  , ( -- missing_value: new in postgres 11
      CASE WHEN col.atthasmissing
        THEN col.attmissingval
        ELSE NULL
      END
    ) AS missing_value -- anyarray nullable
  , ( -- info: a 2-byte packed int
      0
      -- 0000 0000 0000 0001 : not_null
        | (CASE WHEN col.attnotnull THEN 1 ELSE 0 END)
      -- 0000 0000 0000 0110 : identity
        | (
            CASE col.attidentity
              WHEN ''  THEN 1<<1 -- ''  => not an identity column
              WHEN 'a' THEN 2<<1 -- 'a' => always generated
              WHEN 'd' THEN 3<<1 -- 'd' => generated by default
              ELSE          0
            END
          )
      -- 0000 0000 0001 1000 : generation
        | (
            CASE col.attgenerated
              WHEN ''  THEN 1<<3 -- not generated
              WHEN 's' THEN 2<<3 -- stored
              ELSE          0
            END
          )
      -- 0000 0000 0010 0000 : is_local
        | (CASE WHEN col.attislocal THEN 1<<5 ELSE 0 END)
      -- TODO: attcompression: new in postgres 14
    ) AS info
  , (
      CASE
        WHEN col.atthasdef THEN pg_catalog.pg_get_expr(col_def.adbin, col_def.adrelid)
        ELSE NULL
      END
   ) AS expr
    -- either generation, identity generation, or default expression OR just null.
  , col.attoptions AS col_options -- text[], 'key=value' strings
  , col.attfdwoptions AS fdw_options -- ^same
  , pg_catalog.col_description(col.attrelid, col.attnum) AS "comment"
FROM (
  SELECT *
  FROM pg_catalog.pg_attribute AS col -- https://www.postgresql.org/docs/current/catalog-pg-attribute.html
  WHERE col.attnum > 0 -- system columns have negative `attnum`, ordinary have >=1
  AND col.atttypid > 0 -- un-dropped columns only
) AS col
INNER JOIN pg_catalog.pg_class AS rel -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON col.attrelid = rel.oid
INNER JOIN pg_catalog.pg_namespace AS rel_schema -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON rel.relnamespace = rel_schema.oid
INNER JOIN pg_catalog.pg_type AS type_ -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON col.atttypid = type_.oid
INNER JOIN pg_catalog.pg_namespace AS type_ns ON type_.typnamespace = type_ns.oid
LEFT JOIN pg_catalog.pg_attrdef AS col_def -- https://www.postgresql.org/docs/current/catalog-pg-attrdef.html
  ON col.atthasdef
  AND col.attrelid = col_def.adrelid
  AND col.attnum = col_def.adnum