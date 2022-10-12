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
  {{- $is_index             := eq .pg_class_category "INDEX" -}}
  {{- $is_view              := eq .pg_class_category "VIEW" -}}
  {{- $is_materialized_view := eq .pg_class_category "MATERIALIZED VIEW" -}}
  {{- $is_sequence          := eq .pg_class_category "SEQUENCE" -}}
  {{- $is_toast             := eq .pg_class_category "TOAST TABLE" -}}
  {{- $is_partitionable     := or $is_table $is_index -}}
  {{- $multi_kind_possible  := or $is_table $is_index $is_view -}}
SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , cls.relnamespace AS schema_oid
    , cls.relname AS name
    , cls.oid
    , cls_space.spcname AS tablespace_name
    , cls.reltablespace AS tablespace_oid
    , cls.relfilenode AS file_node_oid
    , pg_catalog.pg_get_userbyid(cls.relowner) AS owner
    , cls.relowner AS owner_oid
    , cls.relacl AS acl -- aclitem[]
  -- access method details
  {{- if or $is_table $is_index $is_materialized_view }}
    , cls.relam AS access_method_oid
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (sequences, as well as
      --  relations without storage, such as views)
    , access_method.amname AS access_method_name
    , cls.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
  {{- else }} -- omitted for classes other than tables and indices
  {{- end }}
  -- details
    , pg_catalog.obj_description(cls.oid, 'pg_class') AS "description" -- comment?
  {{- if .packed }}
    , (-- info: 2-byte int
       -- 0000 0001 1111 1111 : bools
       -- 0000 1110 0000 0000 : replica identity
       {{- if not .filter_on_persistence }}
       -- 0011 0000 0000 0000 : persistence
       {{- end }}
        0
        {{- if $is_table }}
        | (CASE WHEN cls.relhasindex         THEN 1<<0 ELSE 0 END)
        {{- end }}
        {{- if $is_table }}
        | (CASE WHEN cls.relisshared         THEN 1<<1 ELSE 0 END)
        {{- end }}
        {{ if $is_table -}}
        | (CASE WHEN cls.relhasrules         THEN 1<<2 ELSE 0 END)
        {{- end }}
        | (CASE WHEN cls.relhastriggers      THEN 1<<3 ELSE 0 END)
        | (CASE WHEN cls.relhassubclass      THEN 1<<4 ELSE 0 END)
        | (CASE WHEN cls.relrowsecurity      THEN 1<<5 ELSE 0 END)
        | (CASE WHEN cls.relforcerowsecurity THEN 1<<6 ELSE 0 END)
        {{- if $is_partitionable }}
        | (CASE WHEN cls.relispartition      THEN 1<<7 ELSE 0 END)
        {{- end }}
        {{- if (or $is_materialized_view $is_view) }}
        | (CASE WHEN cls.relispopulated      THEN 1<<8 ELSE 0 END)
        {{- end }}
        | ((
            CASE cls.relreplident
              WHEN 'd' THEN 1 -- default (primary key, if any),
              WHEN 'n' THEN 2 -- nothing,
              WHEN 'f' THEN 3 -- all columns,
              WHEN 'i' THEN 4 -- index with indisreplident set (same as nothing
                              -- if the index used has been dropped)
              ELSE          0
            END
          )<<9)
        {{- if or (not .filter_on_persistence) (not $is_materialized_view) }}
        | ((
            CASE cls.relpersistence
              WHEN 'p' THEN 1
              WHEN 'u' THEN 2
              WHEN 't' THEN 3
              ELSE          0
            END
          )<<11)
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
  {{- if not $is_toast}}
    , cls.reltype AS type_oid -- references pg_type.oid
      -- The OID of the data type that corresponds to this table's row type, if
      -- any; zero for TOAST tables, which have no pg_type entry
      -- type name, schema, type owner should be the same as the table's.
  {{- end }}
  {{- if $is_table }}
    , cls.reloftype AS underlying_composite_type_oid
      -- For typed tables, the OID of the underlying composite type; zero for all
      -- other relations
      -- Q: does this apply to partitioned tables?
    -- TODO: split out query identifying typed tables
  {{- end }}
  {{- if $is_table }}
    , underlying_composite_type.typname AS underlying_composite_type_name
  {{- end }}
    , cls.reltuples AS approximate_number_of_rows
    , (
        CASE
          WHEN cls.relispartition THEN pg_catalog.pg_get_expr(cls.relpartbound, cls.oid, true)
          ELSE NULL
        END
      ) AS partition_bound
    , cls.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    , cls.relallvisible AS n_pages_all_visible
    , cls.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
    , cls.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
  {{- if or $is_view $is_materialized_view }}
    , pg_catalog.pg_get_viewdef(cls.oid, true) AS view_definition
  {{- end }}
FROM pg_catalog.pg_class AS cls -- https://www.postgresql.org/docs/current/catalog-pg-class.html
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON
  {{- if not $multi_kind_possible }}
    cls.relkind = '{{.kind}}' AND
  {{- else if .filter_on_kind }}
    ( -- validate input parameter: kind
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
    ) AND
    cls.relkind = :'kind' AND
  {{- else if $is_table }}
    cls.relkind IN ('r', 'p') AND
  {{- else if $is_view }}
    cls.relkind IN ('v', 'm') AND
  {{- else if $is_index }}
    cls.relkind IN ('i', 'I') AND
  {{- end }}
  {{- if .filter_on_persistence }}
    ( --validate input parameter: persistence
      CASE :'persistence'
        WHEN 'p' THEN true -- permanent table
        WHEN 'u' THEN true -- unlogged table: not dropped at a session
        WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
        ELSE (1/0)::BOOLEAN -- error: parameter persistence must be either 'p', 'u', or 't'
      END
    ) AND
    cls.relpersistence = :'persistence' AND
  {{- end }}
  {{- if .filter_on_partitioning }}
    cls.relispartition = :partitioning AND
  {{- end }}
    cls.relnamespace = ns.oid
LEFT JOIN pg_catalog.pg_am AS access_method -- https://www.postgresql.org/docs/current/catalog-pg-am.html
  ON cls.relam > 0 AND cls.relam = access_method.oid
LEFT JOIN pg_catalog.pg_tablespace AS cls_space -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
  ON (cls.reltablespace = cls_space.oid)
{{- if not (or $is_sequence $is_toast) }}
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (cls.reloftype = underlying_composite_type.oid)
{{- end }}
