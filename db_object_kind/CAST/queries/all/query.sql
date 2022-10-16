SELECT
    src_ns.nspname AS source_type_schema
  , src_owner.rolname AS source_type_owner_name
  , src.typname AS source_type_name
  , src_ns.nspname AS source_type_schema
  , src_owner.rolname AS source_type_owner_name
  , target_.typname AS target_type_name
  , fn.proname AS cast_fn_name
  , cast_.castcontext
    -- 'e' => only as an explicit cast
    -- 'a' => implicitly in assignment OR as an explicit cast
    -- 'i' => implicitly in expressions OR implicitly in assignment OR as an explicit cast
  , cast_.castmethod
    -- 'f' => the function specified in the castfunc field is used
    -- 'i' => the input/output functions are used. b means that the types are binary-coercible, thus no conversion is required.
FROM pg_catalog.pg_cast AS cast_ -- https://www.postgresql.org/docs/current/catalog-pg-cast.html
INNER JOIN pg_catalog.pg_type AS src -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON cast_.castsource = src.oid
INNER JOIN pg_catalog.pg_namespace AS src_ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON src.typnamespace = src_ns.oid
INNER JOIN pg_catalog.pg_authid AS src_owner -- https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON src.typowner = src_owner.oid
INNER JOIN pg_catalog.pg_type AS target_
  ON cast_.casttarget = target_.oid
INNER JOIN pg_catalog.pg_namespace AS target_ns
  ON src.typnamespace = target_ns.oid
INNER JOIN pg_catalog.pg_authid AS target_owner
  ON target_.typowner = target_owner.oid
LEFT JOIN (
    pg_catalog.pg_proc AS fn -- https://www.postgresql.org/docs/current/catalog-pg-proc.html
    INNER JOIN pg_catalog.pg_namespace AS fn_ns
      ON fn.pronamespace = fn_ns.oid
    INNER JOIN pg_catalog.pg_authid AS fn_owner
      ON fn.proowner = fn_owner.oid
  )
  ON cast_.castfunc > 0 -- if zero, doesn't require a function
  AND cast_.castfunc = fn.oid
