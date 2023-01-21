SELECT
    trigger_.evtname AS "name" -- must be unique within a database
  , trigger_.evtevent AS event_name
    -- the event for which this trigger fires (what are the possible values?)
  , pg_catalog.pg_get_userbyid(trigger_.evtowner) AS owner_name
  , fn.proname AS handler_fn_name
  , trigger_.evtenabled AS session_replication_role_modes
    -- Controls in which session_replication_role modes the trigger fires.
    --  'O' => in "origin" and "local" modes
    --  'D' => disabled
    --  'R' => in "replica" mode
    --  'A' => always.
  , trigger_.evttags AS tags -- text[] | null
    -- Command tags for which this trigger will fire. If NULL, the firing of
    -- this trigger is not restricted on the basis of the command tag.
  , pg_catalog.obj_description(trigger_.oid, 'pg_event_trigger') AS "comment"
FROM pg_catalog.pg_event_trigger AS trigger_ -- https://www.postgresql.org/docs/current/catalog-pg-event-trigger.html
LEFT JOIN pg_catalog.pg_proc AS fn ON trigger_.evtfoid = fn.oid
