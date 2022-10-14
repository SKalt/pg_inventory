SELECT
  -- namespacing and ownership
      tbl.schema_name
    , tbl.schema_oid
    , tbl.name
    , tbl.oid
    , tbl.tablespace_name
    , tbl.tablespace_oid
    , tbl.file_node_oid
    , tbl.owner
    , tbl.owner_oid
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
    , tbl.type_oid
    , tbl.n_pages
    , tbl.n_pages_all_visible
    , tbl.n_user_columns
    , tbl.n_check_constraints
  -- foreign-table specific
    , foreign_table.ftoptions AS foreign_table_options
    , foreign_table.ftserver AS server_oid
    , foreign_server.srvname AS server_name
FROM pg_catalog.pg_foreign_table AS foreign_table
INNER JOIN (
  {{ include . "file://./../TABLE/many.sql.tpl" | indent 1 }}
  ORDER BY oid
) AS tbl ON foreign_table.ftrelid = tbl.oid
INNER JOIN pg_catalog.pg_foreign_server AS foreign_server
  ON foreign_table.ftserver = foreign_server.oid