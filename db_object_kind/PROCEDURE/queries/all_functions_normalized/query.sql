SELECT
    fn.oid
  , fn.pronamespace AS schema_oid
  , fn.proname AS function_name
  , fn.proowner AS owner_oid
  , fn.prolang AS language_oid
  , fn.proacl AS access_privileges--  aclitem[]
    -- Implementation language or call interface of this function
  , fn.procost AS estimated_execution_cost
    -- float4 (in units of cpu_operator_cost); if proretset, this is cost per row returned
  , fn.prorows AS estimated_n_rows -- float4
    -- Estimated number of result rows (zero if not proretset)
  , fn.provariadic AS variadic_type_oid -- can be 0
    -- Data type of the variadic array parameter's elements, if present
  , fn.prosupport AS planner_support_fn_oid
  , fn.prokind AS kind
    -- 'f' => normal function
    -- 'p' => procedure
    -- 'a' => aggregate function
    -- 'w' => window function
  , fn.provolatile AS volatility
    -- whether the function's result depends only on its input arguments, or is affected by outside factors.
    -- 'i' => "immutable" functions: always deliver the same result for the same inputs.
    -- 's' => "stable" functions: results (for fixed inputs) do not change within a scan.
    -- 'v' => "volatile" functions: results might change at any time. (Use v also for functions with side-effects, so that calls to them cannot get optimized away.)
  , fn.proparallel AS parallelizability
    -- whether the function can be safely run in parallel mode.
    -- 's' => safe to run in parallel mode without restriction.
    -- 'r' => can be run in parallel mode, but their execution is restricted to
    --        the parallel group leader; parallel worker processes cannot invoke
    --        these functions.
    -- 'u' => unsafe in parallel mode; the presence of such a function forces a
    --        serial execution plan.
  , fn.prosecdef AS is_security_definer
  , fn.proleakproof AS has_no_side_effects
    -- No information about the arguments is conveyed except via the return value.
    -- Any function that might throw an error depending on the values of its
    -- arguments is not leak-proof.
  , fn.proisstrict AS is_strict
    -- Function returns null if any call argument is null. In that case the
    -- function won't actually be called at all. Functions that are not "strict"
    -- must be prepared to handle null inputs.
  , fn.proretset AS returns_a_set
    -- fn returns multiple values of the specified data type
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
  , pg_catalog.obj_description(fn.oid, 'pg_proc') AS "comment"
FROM pg_catalog.pg_proc AS fn -- https://www.postgresql.org/docs/current/catalog-pg-proc.html