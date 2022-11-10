SELECT
    ns.nspname AS schema_name
  , op.oprname AS "name"
  , pg_catalog.pg_get_userbyid(op.oprowner) AS owner_name
  -- TODO: packed representation
  , op.oprkind
    -- 'b' = infix operator ("both")
    -- 'l' = prefix operator ("left")
  , op.oprcanmerge AS supports_merge_joins
  , op.oprcanhash AS supports_hash_joins
  , left_operand_type_schema.nspname AS left_operand_type_schema
  , left_operand_type.typname AS left_operand_type
  , right_operand_type_schema.nspname AS right_operand_type_schema
  , right_operand_type.typname AS right_operand_type
  , result_type_schema.nspname AS result_type_schema
  , result_type.typname AS result_type

  , commutator_operator_schema.nspname AS commutator_operator_schema
  , commutator_operator.oprname AS commutator_operator
  , negator_operator_schema.nspname AS negator_operator_schema
  , negator_operator.oprname AS negator_operator

  , fn_schema.nspname AS fn_schema
  , fn.proname AS fn
  , restriction_selectivity_estimation_fn_schema.nspname AS restriction_selectivity_estimation_fn_schema
  , restriction_selectivity_estimation_fn.proname AS restriction_selectivity_estimation_fn
  , join_fn_schema.nspname AS join_fn_schema
  , join_fn.proname AS join_fn
  , join_selectivity_estimation_fn_schema.nspname AS join_selectivity_estimation_fn_schema
  , join_selectivity_estimation_fn.proname AS join_selectivity_estimation_fn
FROM pg_catalog.pg_operator AS op -- https://www.postgresql.org/docs/current/catalog-pg-operator.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON op.oprnamespace = ns.oid
LEFT JOIN (
  pg_catalog.pg_type AS left_operand_type -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  INNER JOIN pg_catalog.pg_namespace AS left_operand_type_schema
    ON left_operand_type.typnamespace = left_operand_type_schema.oid
) ON op.oprleft = left_operand_type.oid

LEFT JOIN (
  pg_catalog.pg_type AS right_operand_type
  INNER JOIN pg_catalog.pg_namespace AS right_operand_type_schema
    ON right_operand_type.typnamespace = right_operand_type_schema.oid
) ON op.oprright = right_operand_type.oid

LEFT JOIN (
  pg_catalog.pg_type AS result_type
  INNER JOIN pg_catalog.pg_namespace AS result_type_schema
    ON result_type.typnamespace = result_type_schema.oid
) ON op.oprresult = result_type.oid

LEFT JOIN (
  pg_catalog.pg_operator AS commutator_operator
  INNER JOIN pg_namespace AS commutator_operator_schema
    ON commutator_operator.oprnamespace = commutator_operator_schema.oid
) ON op.oprcom = commutator_operator.oid

LEFT JOIN (
  pg_catalog.pg_operator AS negator_operator
  INNER JOIN pg_namespace AS negator_operator_schema
    ON negator_operator.oprnamespace = negator_operator_schema.oid
) ON op.oprnegate = negator_operator.oid

LEFT JOIN (
  pg_catalog.pg_proc AS fn -- https://www.postgresql.org/docs/current/catalog-pg-proc.html
  INNER JOIN pg_namespace AS fn_schema
    ON fn.pronamespace = fn_schema.oid
) ON op.oprcode = fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS restriction_selectivity_estimation_fn
  INNER JOIN pg_namespace AS restriction_selectivity_estimation_fn_schema
    ON restriction_selectivity_estimation_fn.pronamespace = restriction_selectivity_estimation_fn_schema.oid
) ON op.oprrest = restriction_selectivity_estimation_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS join_fn
  INNER JOIN pg_namespace AS join_fn_schema
    ON join_fn.pronamespace = join_fn_schema.oid
) ON op.oprcode = join_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS join_selectivity_estimation_fn
  INNER JOIN pg_namespace AS join_selectivity_estimation_fn_schema
    ON join_selectivity_estimation_fn.pronamespace = join_selectivity_estimation_fn_schema.oid
) ON op.oprcode = join_selectivity_estimation_fn.oid

