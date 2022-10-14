SELECT
    fn.pronamespace AS schema_oid
  , ns.nspname AS schema_name
  , fn.oid AS function_oid
  , fn.proname AS function_name
  , fn.proowner AS owner_oid
  , pg_catalog.pg_get_userbyid(fn.proowner) AS owner_name
  , fn.proacl AS access_privileges--  aclitem[]
  , fn.prolang AS language_oid
    -- Implementation language or call interface of this function
  , fn.procost AS estimated_execution_cost
    -- float4 (in units of cpu_operator_cost); if proretset, this is cost per row returned
  , fn.prorows AS estimated_n_rows -- float4
    -- Estimated number of result rows (zero if not proretset)
  , fn.provariadic AS arg_array_type_oid -- oid (references pg_type.oid)
  -- Data type of the variadic array parameter's elements, or zero if the
  -- function does not have a variadic parameter
  , fn.prosupport AS planner_support_fn_oid -- zero if none
  , ( -- info: 2-byte int
      -- 00000000 00000011 -- fn kind
      -- 00000000 00001100 -- fn volatility
      -- 00000000 00110000 -- parallelizability
      -- 00000011 11000000 -- bools
      -- TODO: consider packing n_args_with_defaults into the remaining 6 bits?
      0
      | (
          CASE fn.provolatile
            WHEN 'i' THEN 1<<2 -- "immutable" functions: always deliver the same
                               -- result for the same inputs.
            WHEN 's' THEN 2<<2 -- "stable" functions: results (for fixed inputs)
                               -- do not change within a scan.
            WHEN 'v' THEN 3<<2 -- "volatile" functions: results might change at any time. (Use v also for functions with side-effects, so that calls to them cannot get optimized away.)
            ELSE 0
          END
        )
      | (
          CASE fn.proparallel
            WHEN 's' THEN 1<<4 -- safe to run in parallel mode without restriction.
            WHEN 'r' THEN 2<<4 -- can be run in parallel mode, but their execution
                               -- is restricted to the parallel group leader;
                               -- parallel worker processes cannot invoke these
                               -- functions.
            WHEN 'u' THEN 3<<4 -- unsafe in parallel mode; the presence of such
                               -- a function forces a serial execution plan.
            ELSE 0
          END
        )
      | CASE WHEN fn.prosecdef    THEN 1<<6 ELSE 0 END
      | CASE WHEN fn.proleakproof THEN 1<<7 ELSE 0 END
      | CASE WHEN fn.proisstrict  THEN 1<<8 ELSE 0 END
      | CASE WHEN fn.proretset    THEN 1<<9 ELSE 0 END
    )::INT2 AS info
  , fn.pronargs AS n_args -- int2
  , fn.pronargdefaults AS n_args_with_defaults -- int2
  , fn.prorettype AS return_type_oid
  , pg_catalog.pg_get_function_arguments(fn.oid) AS call_signature
    -- text with argument defaults
  , pg_catalog.pg_get_function_result(fn.oid) AS return_signature
    -- text or null for procedures
  , fn.prosrc AS fn_src
    -- tells the function handler how to invoke the function. It might be the
    -- actual source code of the function for interpreted languages, a link
    -- symbol, a file name, or just about anything else, depending on the
    -- implementation language/call convention.
  , fn.probin AS how_to_invoke
    -- text: Additional information about how to invoke the function. Again, the
    -- interpretation is language-specific.
  , fn.proconfig as runtime_config_vars
FROM pg_catalog.pg_proc AS fn
INNER JOIN pg_catalog.pg_namespace AS ns ON
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
  NOT EXISTS ( -- filter out fns that are managed by extensions
    SELECT 1
    FROM pg_catalog.pg_depend AS dependency
    WHERE
      fn.oid = dependency.objid
      AND dependency.deptype = 'e'
    LIMIT 1
  ) AND
  (
    CASE :'kind'
      WHEN 'f' THEN true -- normal function
      WHEN 'p' THEN true -- procedure
      WHEN 'a' THEN true -- aggregate function
      WHEN 'w' THEN true -- window function
      ELSE (1/0)::BOOLEAN -- kind must be one of 'f', 'p', 'a', 'w'
    END
  ) AND
  fn.prokind = :'kind' AND
  fn.pronamespace = ns.oid
INNER JOIN pg_catalog.pg_language AS lang ON
  fn.prolang = lang.oid

