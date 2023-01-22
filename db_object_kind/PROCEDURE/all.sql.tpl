SELECT
    ns.nspname AS schema_name
  , fn.proname AS function_name
  , pg_catalog.pg_get_userbyid(fn.proowner) AS owner_name
  , lang.lanname AS language_name
  , fn.proacl AS access_privileges--  aclitem[]
    -- Implementation language or call interface of this function
  , fn.procost AS estimated_execution_cost
    -- float4 (in units of cpu_operator_cost); if proretset, this is cost per row returned
  , fn.prorows AS estimated_n_rows -- float4
    -- Estimated number of result rows (zero if not proretset)
  , variadic_type_schema.nspname AS variadic_type_schema
  , variadic_type.typname AS variadic_type
  -- Data type of the variadic array parameter's elements, or zero if the
  -- function does not have a variadic parameter
  , planner_support_fn_schema.nspname AS planner_support_fn_schema
  , planner_support_fn.proname AS planner_support_fn -- null if none
  {{- if not .packed }}
  {{- if (not .filter_by_kind) }}
  , fn.prokind AS kind
    -- 'f' => normal function
    -- 'p' => procedure
    -- 'a' => aggregate function
    -- 'w' => window function
  {{- end }}
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
  {{- else }}
  , ( -- info: 2-byte int
      -- 00000000 00000011 -- fn kind
      -- 00000000 00001100 -- fn volatility
      -- 00000000 00110000 -- parallelizability
      -- 00000011 11000000 -- bools
      -- TODO: consider packing n_args_with_defaults into the remaining 6 bits?
      0
      {{- if (not .filter_by_kind) }}
      | (
          CASE fn.prokind
            WHEN 'f' THEN 1<<0 -- normal function
            WHEN 'p' THEN 2<<0 -- procedure
            WHEN 'a' THEN 3<<0 -- aggregate function
            WHEN 'w' THEN 4<<0 -- window function
            ELSE 0
          END
        )
      {{- end }}
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
  {{- end }}
  , fn.pronargs AS n_args -- int2
  , fn.pronargdefaults AS n_args_with_defaults -- int2
  , return_type_schema.nspname AS return_type_schema
  , return_type.typname AS return_type
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
INNER JOIN pg_catalog.pg_namespace AS ns ON
  {{ include . "file://./../SCHEMA/exclude_extensions.sql.tpl" | indent 1 }} AND
  NOT EXISTS ( -- filter out fns that are managed by extensions
    SELECT 1
    FROM pg_catalog.pg_depend AS dependency
    WHERE
      fn.oid = dependency.objid
      AND dependency.deptype = 'e'
    LIMIT 1
  ) AND
  {{- if .filter_by_kind }}
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
  {{- end }}
  fn.pronamespace = ns.oid
INNER JOIN pg_catalog.pg_language AS lang -- https://www.postgresql.org/docs/current/catalog-pg-language.html
  ON fn.prolang = lang.oid
LEFT JOIN (
  pg_catalog.pg_type AS variadic_type
  INNER JOIN pg_catalog.pg_namespace AS variadic_type_schema
    ON variadic_type.typnamespace = variadic_type_schema.oid
) ON fn.provariadic = variadic_type.oid
LEFT JOIN (
  pg_catalog.pg_type AS return_type
  INNER JOIN pg_catalog.pg_namespace AS return_type_schema
    ON return_type.typnamespace = return_type_schema.oid
) ON fn.prorettype = return_type.oid
LEFT JOIN (
  pg_catalog.pg_proc AS planner_support_fn
  INNER JOIN pg_catalog.pg_namespace AS planner_support_fn_schema
    ON planner_support_fn.pronamespace = planner_support_fn_schema.oid
) ON fn.prosupport = planner_support_fn.oid
