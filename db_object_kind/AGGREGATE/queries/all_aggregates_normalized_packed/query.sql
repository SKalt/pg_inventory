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
  -- comments are stored related to the fn in pg_proc that aggfnoid references
FROM pg_catalog.pg_aggregate AS agg -- https://postgresql.org/docs/current/catalog-pg-aggregate.html