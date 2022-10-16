SELECT
  -- namespacing and ownership
      tbl.schema_name
    , tbl.name
    , tbl.tablespace_name
    , tbl.owner
  -- access method details
    , tbl.acl -- aclitem[]
  -- details
    , tbl.description
  {{- if .packed }}
    , tbl.info
  {{- else }}
    , tbl.replica_identity
    , tbl.persistence
  {{- end }}
    , tbl.n_pages
    , tbl.n_pages_all_visible
    , tbl.n_user_columns
    , tbl.n_check_constraints
  -- foreign-table specific
    , foreign_table.ftoptions AS foreign_table_options
    , foreign_server.srvname AS server_name
FROM pg_catalog.pg_foreign_table AS foreign_table
INNER JOIN pg_catalog.pg_class AS cls ON foreign_table.ftrelid = cls.oid
INNER JOIN pg_catalog.pg_namespace AS ns ON cls.relnamespace = ns.oid
INNER JOIN (
  {{ include . "file://./../TABLE/many.sql.tpl" | indent 1 }}
) AS tbl ON ns.nspname = tbl.schema_name AND cls.relname = tbl.name
INNER JOIN pg_catalog.pg_foreign_server AS foreign_server
  ON foreign_table.ftserver = foreign_server.oid