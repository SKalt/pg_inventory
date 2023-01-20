SELECT
  agg.aggfnoid AS fn_oid
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