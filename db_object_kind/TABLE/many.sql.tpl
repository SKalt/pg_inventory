SELECT
  -- namespacing and ownership
      ns.nspname AS schema_name
    , tbl.relnamespace AS schema_oid
    , tbl.relname AS table_name
    , tbl.oid
    , tbl_space.spcname AS tablespace_name
    , tbl.reltablespace AS tablespace_oid
    , pg_catalog.pg_get_userbyid(tbl.relowner) AS table_owner
    , tbl.relowner AS table_owner_oid
    , tbl.relacl AS acl -- aclitem[]
  -- access method details
    -- TODO: fetch access method name, etc.
    , tbl.relam AS access_method_oid
      -- If this is a table or an index, the access method used (heap, B-tree,
      -- hash, etc.); otherwise zero (zero occurs for sequences, as well as
      --  relations without storage, such as views)
    , tbl.reloptions AS access_method_options
      -- Access-method-specific options, as "keyword=value" strings
    , pg_catalog.obj_description(tbl.oid, 'pg_class') AS "description" -- ?
  {{- if .packed }}
    , (/* info: 2-byte int
          0000 0001 1111 1111 : bools
          0000 1110 0000 0000 : replica identity
        {{- if not .filter_on_psersistence }}
          0011 0000 0000 0000 : persistence
        {{- end }}
        */
        0
        | (CASE WHEN tbl.relhasindex         THEN 1<<0 ELSE 0 END)
        | (CASE WHEN tbl.relisshared         THEN 1<<1 ELSE 0 END)
        | (CASE WHEN tbl.relhasrules         THEN 1<<2 ELSE 0 END)
        | (CASE WHEN tbl.relhastriggers      THEN 1<<3 ELSE 0 END)
        | (CASE WHEN tbl.relhassubclass      THEN 1<<4 ELSE 0 END)
        | (CASE WHEN tbl.relrowsecurity      THEN 1<<5 ELSE 0 END)
        | (CASE WHEN tbl.relforcerowsecurity THEN 1<<6 ELSE 0 END)
        | (CASE WHEN tbl.relispartition      THEN 1<<7 ELSE 0 END)
      {{- if eq .pg_class_kind "MATERIALIZED_VIEW" }}
        | (CASE WHEN tbl.relispopulated      THEN 1<<8 ELSE 0 END)
      {{- end }}
        | ((
            CASE tbl.relreplident
              WHEN 'd' THEN 1 -- default (primary key, if any),
              WHEN 'n' THEN 2 -- nothing,
              WHEN 'f' THEN 3 -- all columns,
              WHEN 'i' THEN 4 -- index with indisreplident set (same as nothing
                              -- if the index used has been dropped)
              ELSE          0
            END
          )<<9)
        {{- if not .filter_on_persistence }}
        | ((
            CASE tbl.relpersistence
              WHEN 'p' THEN 1
              WHEN 'u' THEN 2
              WHEN 't' THEN 3
              ELSE          0
            END
          )<<11)
      )::INT2 AS info
  {{- else }}
    , tbl.relreplident AS replica_identity-- char
      -- Columns used to form "replica identity" for rows:
      -- d = default (primary key, if any)
      -- n = nothing
      -- f = all columns
      -- i = index with indisreplident set (same as nothing if the index used has been dropped)
    , tbl.relhasindex AS has_index
      -- True if this is a table and it has (or recently had) any indexes
    , tbl.relisshared AS is_shared
      -- whether this table is shared across all databases in the cluster.
      -- Only certain system catalogs (such as pg_database) are shared.
    , tbl.relhasrules AS has_rules
      -- True if table has (or once had) rules; see pg_rewrite catalog
    , tbl.relhastriggers AS has_triggers
      -- True if table has (or once had) triggers; see pg_trigger catalog
    , tbl.relhassubclass AS has_subclass
      -- True if table or index has (or once had) any inheritance children
    , tbl.relrowsecurity AS has_row_level_security
      -- True if table has row-level security enabled; see pg_policy catalog
    , tbl.relforcerowsecurity AS row_level_security_enforced_on_table_owner
      -- if row-level security (when enabled) will also apply to table owner; see pg_policy catalog
  {{- if eq .pg_class_kind "MATERIALIZED VIEW" }}
    -- , tbl.relispopulated AS is_populated
    --   -- Only false for some materialized views
  {{- end }}
    , tbl.relispartition AS is_partition
    {{- if not .filter_on_persistence }}
    , tbl.relpersistence AS table_persistence
      -- p => permanent table
      -- u => unlogged table: not dropped at a session
      -- t => temporary table: unlogged **and** dropped at the end of a session.
    {{- end }}
  {{- end }}
    , tbl.reltype AS table_type_oid -- references pg_type.oid
      -- The OID of the data type that corresponds to this table's row type, if
      -- any; zero for TOAST tables, which have no pg_type entry
      -- type name, schema, type owner should be the same as the table's.
    , tbl.reloftype AS underlying_composite_type_oid
      -- For typed tables, the OID of the underlying composite type; zero for all
      -- other relations
      -- Q: does this apply to partitioned tables?
    -- TODO: split out query identifying typed tables
    , underlying_composite_type.typname AS underlying_composite_type_name
    , tbl.reltuples AS approximate_number_of_rows
    , (
        CASE
          WHEN tbl.relispartition THEN pg_catalog.pg_get_expr(tbl.relpartbound, tbl.oid, true)
          ELSE NULL
        END
      ) AS partition_bound
    , tbl.relpages AS n_pages -- int4: updated by vacuum, analyze, create index
    , tbl.relallvisible AS n_pages_all_visible
    , tbl.relnatts AS n_user_columns
      -- Number of user columns in the relation (system columns not counted).
      -- There must be this many corresponding entries in pg_attribute.
    , tbl.relchecks AS n_check_constraints
      -- int2; see pg_constraint catalog
FROM pg_catalog.pg_class AS tbl -- https://www.postgresql.org/docs/current/catalog-pg-class.html
INNER JOIN pg_catalog.pg_namespace AS ns -- see https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON
  {{- if .filter_on_kind }}
    ( -- validate input parameter: table_kind
      CASE :'table_kind'
        WHEN 'r' THEN true -- ordinary
        WHEN 'p' THEN true -- partitioned
        ELSE 1/0 -- error: parameter table_kind must be either 'r' or 'p'
      END
    ) AND
    tbl.relkind = :'table_kind' AND
  {{- end }}
  {{- if .filter_on_persistence }}
    ( --validate input parameter: table_persistence
        CASE :'table_persistence'
          WHEN 'p' THEN true -- permanent table
          WHEN 'u' THEN true -- unlogged table: not dropped at a session
          WHEN 't' THEN true -- temporary table: unlogged **and** dropped at the end of a session.
          ELSE 1/0 -- error: parameter table_persistence must be either 'p', 'u', or 't'
    ) AND
    tbl.relpersistence = :'table_persistence' AND
  {{- end }}
  {{- if .filter_on_partitioning }}
    tbl.relispartition = :table_partitioning AND
  {{- end }}
    tbl.relnamespace = ns.oid
LEFT JOIN pg_tablespace AS tbl_space ON (tbl.reltablespace = tbl_space.oid)
  -- see https://www.postgresql.org/docs/current/catalog-pg-tablespace.html
LEFT JOIN (
    pg_catalog.pg_type AS underlying_composite_type
    INNER JOIN pg_namespace AS underlying_type_ns ON (
      underlying_composite_type.typnamespace = underlying_type_ns.oid
    )
  ) ON (tbl.reloftype = underlying_composite_type.oid)
