{{- /* variables*/ -}}
  {{- /*
    categories:
      TABLE:
        r => ordinary table
        p => partitioned table
      INDEX:
        i => index
        I => partitioned index
      VIEW:
        v => view
        m => materialized view
      MATERIALIZED VIEW: !!!!!!!!!! special subclass
        m => materialized view
      SEQUENCE: S => sequence
      TOAST: t => TOAST table
      COMPOSITE TYPE: c => composite type
      FOREIGN TABLE: f => foreign table
  */ -}}
  {{- $is_table             := eq .pg_class_category "TABLE" -}}
  {{- $is_foreign           := eq .pg_class_category "FOREIGN TABLE" -}}
  {{- $is_index             := eq .pg_class_category "INDEX" -}}
  {{- $is_view              := eq .pg_class_category "VIEW" -}}
  {{- $is_materialized_view := eq .pg_class_category "MATERIALIZED VIEW" -}}
  {{- $is_sequence          := eq .pg_class_category "SEQUENCE" -}}
  {{- $is_toast             := eq .pg_class_category "TOAST TABLE" -}}
  {{- $is_partitionable     := or $is_table $is_index -}}
  {{- $multi_kind_possible  := or $is_table $is_index $is_view -}}
SELECT
  -- namespacing and ownership
    {{- if .oid }}
      cls.oid
    , cls.relnamespace AS schema_oid
    {{- else }}
      ns.nspname AS schema_name
    {{- end }}
    , cls.relname AS "name"
    {{- if .oid }}
    , cls.reltablespace AS tablespace_oid
    , cls.relowner AS owner_oid
    {{- else }}
    , cls_space.spcname AS tablespace_name
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    {{- end }}
    , cls.relacl AS acl -- aclitem[]
  -- access method details
  {{- if or $is_table $is_index $is_materialized_view }}
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (sequences, as well as
      --  relations without storage, such as views or foreign tables)
    {{- if .oid }}
    , cls.relam AS access_method_oid
    {{- else }}
    , access_method.amname AS access_method_name
    {{- end }}
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
  {{- else }} -- omitted for classes other than tables and indices
  {{- end }}
  -- details
  {{- if .packed }}
    , (-- info: 2-byte int
        0
      -- 0000 0000 0000 0001 : has_index
        {{- if not $is_table }} -- omitted: table-only
        {{- else }}
        | (CASE WHEN cls.relhasindex         THEN 1<<0 ELSE 0 END)
        {{- end }}
      -- 0000 0000 0000 0010 : is_shared
        {{- if not $is_table }} -- omitted: table-only
        {{- else }}
        | (CASE WHEN cls.relisshared         THEN 1<<1 ELSE 0 END)
        {{- end }}
      -- 0000 0000 0000 0100 : has_rules
        {{- if not $is_table -}} -- omitted: table-only
        {{- else }}
        | (CASE WHEN cls.relhasrules         THEN 1<<2 ELSE 0 END)
        {{- end }}
      -- 0000 0000 0000 1000 : has_triggers
        | (CASE WHEN cls.relhastriggers      THEN 1<<3 ELSE 0 END)
      -- 0000 0000 0001 0000 : has_subclass
        | (CASE WHEN cls.relhassubclass      THEN 1<<4 ELSE 0 END)
      -- 0000 0000 0010 0000 : has_row_level_security
        | (CASE WHEN cls.relrowsecurity      THEN 1<<5 ELSE 0 END)
      -- 0000 0000 0100 0000 : row_level_security_enforced_on_owner
        | (CASE WHEN cls.relforcerowsecurity THEN 1<<6 ELSE 0 END)
      -- 0000 0000 1000 0000 : row_level_security_enforced_on_owner
        {{- if $is_partitionable }}
        | (CASE WHEN cls.relispartition      THEN 1<<7 ELSE 0 END)
        {{- else }} -- omitted: only applicable to tables or indices
        {{- end }}
      -- 0000 0001 0000 0000 : is_populated
        {{- if (or $is_materialized_view $is_view) }}
        | (CASE WHEN cls.relispopulated      THEN 1<<8 ELSE 0 END)
        {{- else }} -- omitted: only for materialized/regular views
        {{- end }}
      -- 0000 1110 0000 0000 : replica identity
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
        {{- if or (not .filter_on_persistence) (not $is_materialized_view) (not $is_foreign) }}
        | ((
            CASE cls.relpersistence
              WHEN 'p' THEN 1
              WHEN 'u' THEN 2
              WHEN 't' THEN 3
              ELSE          0
            END
          )<<11)
        {{- else }} -- omitted
        {{- end }}
      )::INT2 AS info
  {{- else }}
    , cls.relreplident AS replica_identity -- char
      -- Columns used to form "replica identity" for rows:
      -- d = default (primary key, if any)
      -- n = nothing
      -- f = all columns
      -- i = index with indisreplident set (same as nothing if the index used has been dropped)
    {{- if $is_table }}
    , cls.relhasindex AS has_index
      -- True if this is a table and it has (or recently had) any indexes
    {{- end }}
    {{- if $is_table }}
    , cls.relisshared AS is_shared
      -- whether this table is shared across all databases in the cluster.
      -- Only certain system catalogs (such as pg_database) are shared.
    {{- end }}
    {{- if $is_table }}
    , cls.relhasrules AS has_rules
      -- True if table has (or once had) rules; see pg_rewrite catalog
    {{- end }}
    {{- if $is_table }}
    , cls.relhastriggers AS has_triggers
      -- True if table has (or once had) triggers; see pg_trigger catalog
    {{- end }}
    {{- if (or $is_table $is_index) }}
    , cls.relhassubclass AS has_subclass
      -- True if table or index has (or once had) any inheritance children
    {{- end }}
    {{- if $is_table }}
    , cls.relrowsecurity AS has_row_level_security
      -- True if table has row-level security enabled; see pg_policy catalog
    {{- end }}
    {{- if $is_table }}
    , cls.relforcerowsecurity AS row_level_security_enforced_on_owner
      -- if row-level security (when enabled) will also apply to table owner; see pg_policy catalog
    {{- end }}
    {{- if (or $is_view $is_materialized_view) }}
    , cls.relispopulated AS is_populated
      -- Only false for some materialized views
    {{- end }}
    {{- if $is_partitionable }}
    , cls.relispartition AS is_partition
    {{- end }}
    {{ if or (not .filter_on_persistence) (not $is_materialized_view) -}}
    , cls.relpersistence AS persistence
      -- p => permanent table
      -- u => unlogged table: not dropped at a session
      -- t => temporary table: unlogged **and** dropped at the end of a session.
    {{- end }}
  {{- end }}
  {{- if (and $multi_kind_possible (not .filter_on_kind)) }}{{/*
      since relkind would take a nibble, overflowing a smallint's 2-byte limit,
      don't try to pack it and send the 1-byte char over separately.
    */}}
    , cls.relkind AS kind
      -- r => ordinary table
      -- p => partitioned table
      -- i => index
      -- I => partitioned index
      -- S => sequence
      -- t => TOAST table
      -- v => view
      -- m => materialized view
      -- c => composite type
      -- f => foreign table
  {{- end}}
  {{- if $is_table }}
    {{- if .oid }}
    , cls.reloftype AS underlying_composite_type_oid
    {{- else }}
    , underlying_type_ns.nspname AS underlying_type_schema
    , underlying_composite_type.typname AS underlying_composite_type
    {{- end }}
      -- for typed tables
  {{- end }}
    {{ if or $is_view $is_foreign -}} -- omitted: {{ end -}}
    , cls.reltuples AS approximate_number_of_rows
  {{- if $is_partitionable }}
    , (
        CASE
          WHEN cls.relispartition THEN pg_catalog.pg_get_expr(cls.relpartbound, cls.oid, true)
          ELSE NULL
        END
      ) AS partition_bound
  {{- end }}
    {{ if or $is_view $is_foreign -}} -- omitted: {{ end -}}
    , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    {{ if or $is_view $is_foreign -}} -- omitted: {{ end -}}
    , cls.relallvisible AS n_pages_all_visible
    , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
  {{- if or $is_view $is_materialized_view }}
    , pg_catalog.pg_get_viewdef(cls.oid, true) AS view_definition
  {{- else if $is_index }}
    , pg_catalog.pg_get_indexdef(cls.oid) AS index_definition
  {{- else if $is_foreign }}
    , foreign_table.ftoptions AS foreign_table_options
    {{- if .oid }}
    , foreign_table.ftserver AS foreign_server_oid
    {{- else }}
    , foreign_server.srvname AS foreign_server_name
    {{- end }}
  {{- else if $is_sequence }}
  -- sequence-specific info
    , seq.seqstart AS start -- int8
    , seq.seqincrement AS increment -- int8
    , seq.seqmax AS max -- int8
    , seq.seqmin AS min -- int8
    , seq.seqcache AS cache_size -- int8
    , seq.seqcycle AS does_cycle -- bool
    {{- if .oid }}
    , seq.seqtypid AS sequence_type_id
    {{- else }}
    , seq_type.typname AS sequence_type
    , seq_type_schema.nspname AS sequence_type_schema_name
    , pg_catalog.pg_get_userbyid(seq_type.typowner) AS sequence_type_owner_name
    {{- end }}
  {{- end }}
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "comment"
FROM (
  SELECT * FROM pg_catalog.pg_class AS cls
  WHERE 1=1
  {{- if not $multi_kind_possible }}
    AND cls.relkind = '{{.kind}}'
  {{- else if .filter_on_kind }}
    AND ( -- validate input parameter: kind
      CASE :'kind'
        -- r => ordinary table
        -- p => partitioned table
        -- i => index
        -- I => partitioned index
        -- S => sequence
        -- t => TOAST table
        -- v => view
        -- m => materialized view
        -- c => composite type
        -- f => foreign table
      {{- if $is_table }}
        WHEN 'r' THEN true -- ordinary
        WHEN 'p' THEN true -- partitioned
        ELSE (1/0)::BOOLEAN -- error: parameter kind must be either 'r' or 'p'
      {{- else if $is_view }}
        WHEN 'v' THEN true
        WHEN 'm' THEN true
        ELSE (1/0)::BOOLEAN -- error: parameter kind must be either 'v' or 'm'
      {{- else if $is_index }}
        WHEN 'i' THEN true
        WHEN 'I' THEN true
        ELSE (1/0)::BOOLEAN -- error: parameter kind must be either 'i' or 'I'
      {{- end }}
      END
    )
    AND cls.relkind = :'kind'
  {{- else if $is_table }}
    AND cls.relkind IN ('r', 'p')
  {{- else if $is_view }}
    AND cls.relkind IN ('v', 'm')
  {{- else if $is_index }}
    AND cls.relkind IN ('i', 'I')
  {{- end }}
  {{- if .filter_on_persistence }}
    AND ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    )
    AND cls.relpersistence = :'persistence'
  {{- end }}
  {{- if .filter_on_partitioning }}
    AND cls.relispartition = :partitioning
  {{- end }}
) AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
{{- if not .oid }}
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
{{- if $is_table }}
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (cls.reloftype = underlying_composite_type.oid)
{{- end }}
{{- end }}
{{- if $is_foreign }}
INNER JOIN pg_catalog.pg_foreign_table AS foreign_table -- see https://www.postgresql.org/docs/current/catalog-pg-foreign-table.html
  ON cls.oid = foreign_table.ftrelid
{{- if not .oid }}
INNER JOIN pg_catalog.pg_foreign_server AS foreign_server
  ON foreign_table.ftserver = foreign_server.oid
{{- end }}
{{- end }}
{{- if $is_sequence }}
INNER JOIN pg_catalog.pg_sequence AS seq -- https://www.postgresql.org/docs/current/catalog-pg-sequence.html
  ON seq.seqrelid = cls.oid
{{- if not .oid }}
INNER JOIN pg_catalog.pg_type AS seq_type -- https://www.postgresql.org/docs/current/catalog-pg-type.html
  ON seq.seqtypid = seq_type.oid
INNER JOIN pg_catalog.pg_namespace as seq_type_schema
  ON seq_type.typnamespace = seq_type_schema.oid
{{- end }}
{{- end }}
