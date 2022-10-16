SELECT
    rel.schema_name
  , rel.name
  , rel.tablespace_name
  , rel.owner
  , rel.acl
  , rel.description
  , rel.replica_identity
{{- if not .filter_by_persistence }}
  , rel.persistence
{{- end }}
  , rel.approximate_number_of_rows
  , rel.partition_bound
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
FROM pg_catalog.pg_sequence AS seq
INNER JOIN pg_catalog.pg_class AS cls ON seq.seqrelid = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON cls.relnamespace = ns.oid
INNER JOIN (
  {{ include . "file://./../TABLE/many.sql.tpl" | indent 1 }}
) AS rel ON ns.nspname = rel.schema_name AND cls.relname = rel.name
INNER JOIN pg_catalog.pg_type AS type_
  ON seq.seqtypid = type_.oid
INNER JOIN pg_catalog.pg_namespace as type_schema
  ON type_.typnamespace = type_schema.oid
