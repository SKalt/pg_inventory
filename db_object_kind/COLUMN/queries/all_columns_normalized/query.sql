SELECT
  col.attrelid AS relation_oid
  , col.attnum AS col_number -- int2: 1-indexed
  , col.attname AS col_name
  , col.atttypid AS type_oid -- can be 0
  , col.attstattarget AS stats_detail_level -- int4: for ANALYZE
  , col.attndims AS dimension_number -- dimension_number > 0 means array
  , col.atttypmod AS type_length -- int4, for type-specific input and length-coersion, e.g. varchar(n)
  , ( -- missing_value: new in postgres 11
      CASE WHEN col.atthasmissing
        THEN col.attmissingval
        ELSE NULL
      END
    ) AS missing_value -- anyarray nullable
  , col.attnotnull AS not_null -- bool NOTE: all not-null constraints represented here, NOT in pg_constraint
  , col.attislocal AS is_local
  , col.attidentity AS column_identity
    -- '' => not an identity column
    -- 'a' => always generated
    -- 'd' => generated by default
  , col.attgenerated AS col_generated
    -- '' => not generated
    -- 's' => stored
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
LEFT JOIN pg_catalog.pg_attrdef AS col_def -- https://www.postgresql.org/docs/current/catalog-pg-attrdef.html
  ON col.atthasdef
  AND col.attrelid = col_def.adrelid
  AND col.attnum = col_def.adnum