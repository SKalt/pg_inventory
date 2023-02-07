SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , cls.relname AS "name"
    , cls_space.spcname AS tablespace_name
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    , cls.relacl AS acl -- aclitem[]
  -- access method details -- omitted for classes other than tables and indices
  -- details
    , cls.relreplident AS replica_identity -- char
      -- Columns used to form "replica identity" for rows:
      -- d = default (primary key, if any)
      -- n = nothing
      -- f = all columns
      -- i = index with indisreplident set (same as nothing if the index used has been dropped)
    , cls.relpersistence AS persistence
      -- p => permanent table
      -- u => unlogged table: not dropped at a session
      -- t => temporary table: unlogged **and** dropped at the end of a session.
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
    , seq.seqcycle AS does_cycle -- bool
    , seq_type.typname AS sequence_type
    , seq_type_schema.nspname AS sequence_type_schema_name
    , pg_catalog.pg_get_userbyid(seq_type.typowner) AS sequence_type_owner_name
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
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
INNER JOIN pg_catalog.pg_sequence AS seq -- https://www.postgresql.org/docs/current/catalog-pg-sequence.html
  ON seq.seqrelid = cls.oid
INNER JOIN pg_catalog.pg_type AS seq_type -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON seq.seqtypid = seq_type.oid
INNER JOIN pg_catalog.pg_namespace as seq_type_schema
  ON seq_type.typnamespace = seq_type_schema.oid
