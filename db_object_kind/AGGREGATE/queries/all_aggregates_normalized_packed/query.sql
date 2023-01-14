SELECT
  agg.aggfnoid AS fn_oid
  , ( -- info: int2
      0
      -- 0000 0000 0000 0011 -- kind
        | (
            CASE agg.aggkind
              WHEN 'n' THEN 1<<0 -- "normal"
              WHEN 'o' THEN 2<<0 -- "ordered-set"
              WHEN 'h' THEN 3<<0 -- "hypothetical-set"
              ELSE 0
            END
          )
      -- 0000 0000 0000 0100 -- pass_extra_dummy_args_to_final_fn
        | CASE WHEN agg.aggfinalextra THEN 1<<2 ELSE 0 END
      -- 0000 0000 0001 1000 -- final_fn_modifies_transition_state_value
        | (
            CASE agg.aggfinalmodify
              -- Whether the final function modifies the transition state value:
              WHEN 'r' THEN 1<<3 -- the transition state value is read-only
              WHEN 's' THEN 2<<3 -- the aggtransfn cannot be applied after the aggfinalfn
              WHEN 'w' THEN 3<<3 -- it writes on the value
              ELSE 0
            END
          )
      -- 0000 0000 0010 0000 -- pass_extra_dummy_args_to_moving_aggregate_final_fn
        | CASE WHEN agg.aggmfinalextra THEN 1<<5 ELSE 0 END
      -- 0000 0000 1100 0000 -- moving_aggregate_final_fn_modifies_transition_state_value
        | (
            CASE agg.aggmfinalmodify
              -- Whether the moving-aggregate final function modifies the
              -- transition state value:
              WHEN 'r' THEN 1<<6 -- the transition state value is read-only
              WHEN 's' THEN 2<<6 -- the aggtransfn cannot be applied after the aggfinalfn
              WHEN 'w' THEN 3<<6 -- it writes on the value
              ELSE 0
            END
          )
    )::INT2 AS info
  , agg.aggtransfn::OID AS transition_fn_oid
  , agg.aggfinalfn::OID AS final_fn_OID
  , agg.aggcombinefn::OID AS combine_fn_oid
  , agg.aggserialfn::OID AS serialization_fn_oid
  , agg.aggmtransfn::OID AS deserialization_fn_oid
  , agg.aggminvtransfn::OID AS moving_agg_inverse_transition_fn_oid
  , agg.aggmtransfn::OID AS moving_agg_forward_transition_fn_oid
  , agg.aggmfinalfn::OID AS moving_agg_final_fn_oid
  , agg.aggtranstype AS transition_type_oid
  , agg.aggmtranstype AS moving_agg_transition_state_type_oid
  , agg.aggsortop AS sort_op_oid
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
