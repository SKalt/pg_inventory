SELECT
    -- TODO: figure out how to re-use some of the PROCEDURE template here
    ns.nspname AS schema_name
  , fn.proname AS fn
  , agg.aggkind AS kind
    -- 'n' => "normal"
    -- 'o' => "ordered-set"
    -- 'h' => "hypothetical-set"

  , agg.aggfinalextra AS pass_extra_dummy_args_to_final_fn
  , agg.aggfinalmodify AS final_fn_modifies_transition_state_value
    -- Whether the final function modifies the transition state value:
    -- 'r' => the transition state value is read-only
    -- 's' => the aggtransfn cannot be applied after the aggfinalfn
    -- 'w' => it writes on the value

  , agg.aggmfinalextra AS pass_extra_dummy_args_to_moving_aggregate_final_fn
  , agg.aggmfinalmodify moving_aggregate_final_fn_modifies_transition_state_value
    -- Whether the moving-aggregate final function modifies the transition state value:
    -- 'r' => it is read-only
    -- 's' => the aggtransfn cannot be applied after the aggfinalfn
    -- 'w' => it writes on the value
  , agg.aggnumdirectargs AS n_direct_arguments -- int2
    -- Number of direct (non-aggregated) arguments of an ordered-set or
    -- hypothetical-set aggregate, counting a variadic array as one argument.
    -- If equal to pronargs, the aggregate must be variadic and the variadic array
    -- describes the aggregated arguments as well as the final direct arguments.
    -- Always zero for normal aggregates.

  , transition_fn_schema.nspname AS transition_fn_schema_name
  , transition_fn.proname AS transition_fn_name

  , transition_type_schema.nspname AS transition_type_schema_name
  , transition_type.typname AS transition_state_type_name
  , agg.aggtransspace AS approx_transiton_state_avg_bytes
    -- int4; 0 to use a default estimate

  , final_fn_schema.nspname AS final_fn_schema_name
  , final_fn.proname AS final_fn_name

  , combine_fn_schema.nspname AS combine_fn_schema_name
  , combine_fn.proname AS combine_fn_name

  , serialization_fn_schema.nspname AS serialization_fn_schema_name
  , serialization_fn.proname AS serialization_fn_name

  , deserialization_fn_schema.nspname AS deserialization_fn_schema_name
  , deserialization_fn.proname AS deserialization_fn_name

  , moving_agg_forward_transition_fn_schema.nspname AS moving_agg_forward_transition_fn_schema_name
  , moving_agg_forward_transition_fn.proname AS moving_agg_forward_transition_fn_name

  , moving_agg_inverse_transition_fn_schema.nspname AS moving_agg_inverse_transition_fn_schema_name
  , moving_agg_inverse_transition_fn.proname AS moving_agg_inverse_transition_fn_name

  , moving_agg_final_fn_schema.nspname AS moving_agg_final_fn_schema_name
  , moving_agg_final_fn.proname AS moving_agg_final_fn_name

  , sort_op_schema.nspname AS sort_operator_schema
  , sort_op.oprname AS sort_operator

  , moving_agg_transition_state_type_schema.nspname AS moving_agg_transition_state_type_schema_name
  , moving_agg_transition_state_type.typname AS moving_agg_transition_state_type_name
  , agg.aggmtransspace AS moving_agg_transition_state_avg_bytes -- int4; 0 to use default estimate

  , agg.agginitval AS initial_value -- text string repr or null
    -- The initial value of the transition state. This is a text field
    -- containing the initial value in its external string representation.
    -- If this field is null, the transition state value starts out null.
  , agg.aggminitval AS moving_agg_initial_value -- text or null
FROM pg_catalog.pg_aggregate AS agg -- postgresql.org/docs/current/catalog-pg-aggregate.html
INNER JOIN pg_catalog.pg_proc AS fn ON agg.aggfnoid = fn.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON fn.pronamespace = ns.oid
LEFT JOIN (
  pg_catalog.pg_proc AS transition_fn
  INNER JOIN pg_catalog.pg_namespace AS transition_fn_schema
    ON transition_fn.pronamespace = transition_fn_schema.oid
) ON agg.aggtransfn = transition_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS final_fn
  INNER JOIN pg_catalog.pg_namespace AS final_fn_schema
    ON final_fn.pronamespace = final_fn_schema.oid
) ON agg.aggfinalfn = final_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS combine_fn
  INNER JOIN pg_catalog.pg_namespace AS combine_fn_schema
    ON combine_fn.pronamespace = combine_fn_schema.oid
) ON agg.aggcombinefn = combine_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS serialization_fn
  INNER JOIN pg_catalog.pg_namespace AS serialization_fn_schema
    ON serialization_fn.pronamespace = serialization_fn_schema.oid
) ON agg.aggserialfn = serialization_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS deserialization_fn
  INNER JOIN pg_catalog.pg_namespace AS deserialization_fn_schema
    ON deserialization_fn.pronamespace = deserialization_fn_schema.oid
) ON agg.aggmtransfn = deserialization_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS moving_agg_inverse_transition_fn
  INNER JOIN pg_catalog.pg_namespace AS moving_agg_inverse_transition_fn_schema
    ON moving_agg_inverse_transition_fn.pronamespace = moving_agg_inverse_transition_fn_schema.oid
) ON agg.aggminvtransfn = moving_agg_inverse_transition_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS moving_agg_forward_transition_fn
  INNER JOIN pg_catalog.pg_namespace AS moving_agg_forward_transition_fn_schema
    ON moving_agg_forward_transition_fn.pronamespace = moving_agg_forward_transition_fn_schema.oid
) ON agg.aggmtransfn = moving_agg_forward_transition_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS moving_agg_final_fn
  INNER JOIN pg_catalog.pg_namespace AS moving_agg_final_fn_schema
    ON moving_agg_final_fn.pronamespace = moving_agg_final_fn_schema.oid
) ON agg.aggmfinalfn = moving_agg_final_fn.oid

LEFT JOIN (
  pg_catalog.pg_type AS transition_type
  INNER JOIN pg_catalog.pg_namespace AS transition_type_schema
    ON transition_type.typnamespace = transition_type_schema.oid
) ON agg.aggtranstype = transition_type.oid

LEFT JOIN (
  pg_catalog.pg_type AS moving_agg_transition_state_type
  INNER JOIN pg_catalog.pg_namespace AS moving_agg_transition_state_type_schema
    ON moving_agg_transition_state_type.typnamespace = moving_agg_transition_state_type_schema.oid
) ON agg.aggmtranstype = moving_agg_transition_state_type.oid

LEFT JOIN (
  pg_catalog.pg_operator AS sort_op
  INNER JOIN pg_catalog.pg_namespace AS sort_op_schema
    ON sort_op.oprnamespace = sort_op_schema.oid
) ON agg.aggsortop = sort_op.oid
