SELECT
    op.oid
  , op.oprnamespace AS schema_oid
  , op.oprname AS "name"
  , op.oprowner AS owner_oid
  , op.oprkind
    -- 'b' = infix operator ("both")
    -- 'l' = prefix operator ("left")
  , op.oprcanmerge AS supports_merge_joins
  , op.oprcanhash AS supports_hash_joins
  , op.oprleft AS left_operand_type_oid
  , op.oprright AS right_operand_type_oid
  , op.oprresult AS result_type_oid
  , op.oprcom AS commutator_operator_oid
  , op.oprnegate AS negator_operator_oid
  , op.oprcode AS fn_oid
  , op.oprrest AS restriction_selectivity_estimation_fn_oid
  , op.oprcode AS join_fn_oid
  , op.oprjoin AS join_selectivity_estimation_fn_oid

  , pg_catalog.obj_description(op.oid, 'pg_operator')
FROM pg_catalog.pg_operator AS op -- https://www.postgresql.org/docs/current/catalog-pg-operator.html
