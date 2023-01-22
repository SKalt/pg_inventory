SELECT
    rel.schema_name
  , rel.name
  , rel.tablespace_name
  , rel.owner
  , rel.acl
  , rel.description
  , rel.replica_identity
  , rel.persistence
  , rel.approximate_number_of_rows
  , rel.n_pages
  , rel.n_pages_all_visible
  , rel.n_user_columns
-- sequence-specific info
  , seq.seqstart AS start -- int8
  , seq.seqincrement AS increment -- int8
  , seq.seqmax AS max -- int8
  , seq.seqmin AS min -- int8
  , seq.seqcache AS cache_size -- int8
  , seq.seqcycle AS does_cycle -- bool
  , type_.typname AS sequence_type
  , type_schema.nspname AS sequence_type_schema_name
  , pg_catalog.pg_get_userbyid(type_.typowner) AS sequence_type_owner_name
FROM pg_catalog.pg_sequence AS seq -- https://www.postgresql.org/docs/current/catalog-pg-sequence.html
INNER JOIN pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON seq.seqrelid = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
INNER JOIN (
  SELECT
    -- namespacing and ownership
        ns.nspname AS schema_name
      , cls.relname AS name
      , cls_space.spcname AS tablespace_name
      , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
      , cls.relacl AS acl -- aclitem[]
    -- access method details -- omitted for classes other than tables and indices
    -- details
      , pg_catalog.obj_description(cls.oid, 'pg_class') AS "description" -- comment?
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
      , cls.reltuples AS approximate_number_of_rows
      , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
      , cls.relallvisible AS n_pages_all_visible
      , cls.relnatts AS n_user_columns
        -- Number of user columns in the relation (system columns not counted).
        -- There must be this many corresponding entries in pg_attribute.
      , cls.relchecks AS n_check_constraints
        -- int2; see pg_constraint catalog
      , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
  FROM pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
    ON
      cls.relkind = 'S' AND
      cls.relnamespace = ns.oid
  LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
    ON cls.relam > 0 AND cls.relam = access_method.oid
  LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
    ON (cls.reltablespace = cls_space.oid)
  
) AS rel ON ns.nspname = rel.schema_name AND cls.relname = rel.name
INNER JOIN pg_catalog.pg_type AS type_ -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON seq.seqtypid = type_.oid
INNER JOIN pg_catalog.pg_namespace as type_schema
  ON type_.typnamespace = type_schema.oid
