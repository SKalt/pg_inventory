SELECT
  -- namespacing and ownership
      cls.oid
    , cls.relnamespace AS schema_oid
    , cls.relname AS "name"
    , cls.reltablespace AS tablespace_oid
    , cls.relowner AS owner_oid
    , cls.relacl AS acl -- aclitem[]
  -- access method details -- omitted for classes other than tables and indices
  -- details
    , (-- info: 2-byte int
        0
      -- 0000 0000 0000 0001 : has_index -- omitted: table-only
      -- 0000 0000 0000 0010 : is_shared -- omitted: table-only
      -- 0000 0000 0000 0100 : has_rules-- omitted: table-only
      -- 0000 0000 0000 1000 : has_triggers
        | (CASE WHEN cls.relhastriggers      THEN 1<<3 ELSE 0 END)
      -- 0000 0000 0001 0000 : has_subclass
        | (CASE WHEN cls.relhassubclass      THEN 1<<4 ELSE 0 END)
      -- 0000 0000 0010 0000 : has_row_level_security
        | (CASE WHEN cls.relrowsecurity      THEN 1<<5 ELSE 0 END)
      -- 0000 0000 0100 0000 : row_level_security_enforced_on_owner
        | (CASE WHEN cls.relforcerowsecurity THEN 1<<6 ELSE 0 END)
      -- 0000 0000 1000 0000 : is_partition -- omitted: only applicable to tables or indices
      -- 0000 0001 0000 0000 : is_populated -- omitted: only for materialized/regular views
      -- 0000 1110 0000 0000 : replica_identity
        | ((
            CASE cls.relreplident
              WHEN 'd' THEN 1 -- default (primary key, if any)
              WHEN 'n' THEN 2 -- nothing
              WHEN 'f' THEN 3 -- all columns
              WHEN 'i' THEN 4 -- index with indisreplident set (same as nothing
                              -- if the index used has been dropped)
              ELSE          0
            END
          )<<9)
      -- 0011 0000 0000 0000 : persistence
        | ((
            CASE cls.relpersistence
              WHEN 'p' THEN 1
              WHEN 'u' THEN 2
              WHEN 't' THEN 3
              ELSE          0
            END
          )<<11)
      -- 0100 0000 0000 0000 : does_cycle (sequence-specific)
        | (CASE WHEN seq.seqcycle            THEN 1<<14 ELSE 0 END)
      )::INT2 AS info
    -- omitted: , cls.reltuples AS approximate_number_of_rows
    -- omitted: , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    -- omitted: , cls.relallvisible AS n_pages_all_visible
    -- omitted: sequences always have 3 cols: , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
      -- ^This **is** populated for indices.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
  -- sequence-specific info
    , seq.seqstart AS start -- int8
    , seq.seqincrement AS increment -- int8
    , seq.seqmax AS max -- int8
    , seq.seqmin AS min -- int8
    , seq.seqcache AS cache_size -- int8
    , seq.seqtypid AS sequence_type_id
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
    AND cls.relkind = 'S'
    AND ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    )
    AND cls.relpersistence = :'persistence'
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
INNER JOIN pg_catalog.pg_sequence AS seq -- https://www.postgresql.org/docs/current/catalog-pg-sequence.html
  ON seq.seqrelid = cls.oid
