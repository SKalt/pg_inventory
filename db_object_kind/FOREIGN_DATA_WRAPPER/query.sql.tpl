SELECT
  -- namespacing
    {{ if .oid -}} fdw.oid
  , {{  end -}}
    fdw.fdwname AS "name"
  {{- if .oid }}
  , fdw.fdwowner AS owner_oid
  {{- else }}
  , pg_catalog.pg_get_userbyid(fdw.fdwowner) AS owner_name
  {{- end}}
  , fdw.fdwacl AS access_privileges
  , fdw.fdwoptions AS options

  {{- if .oid }}
  , fdw.fdwhandler AS handler_fn_oid
  , fdw.fdwvalidator AS validator_fn_oid
  {{- else }}
  , handler_fn_ns.nspname AS handler_fn_schema_name
  , handler_fn.proname AS handler_fn_name
    -- a handler function that is responsible for supplying execution routines
    -- for the foreign-data wrapper. Null if no handler is provided
  , pg_catalog.pg_get_userbyid(handler_fn.proowner) AS handler_fn_owner

  , validator_fn_ns.nspname AS validator_fn_schema_name
  , validator_fn.proname AS validator_fn_name
    -- A validator function that is responsible for checking the
    -- validity of the options given to the foreign-data wrapper, as well as
    -- options for foreign servers and user mappings using the foreign-data
    -- wrapper. Zero if no validator is provided
  , pg_catalog.pg_get_userbyid(validator_fn.proowner) AS validator_fn_owner
  {{- end }}
FROM pg_catalog.pg_foreign_data_wrapper AS fdw -- https://www.postgresql.org/docs/current/catalog-pg-foreign-data-wrapper.html
{{ if not .oid -}}
LEFT JOIN (
    pg_catalog.pg_proc AS handler_fn -- https://www.postgresql.org/docs/current/catalog-pg-proc.html
    INNER JOIN pg_catalog.pg_namespace AS handler_fn_ns
      ON handler_fn.pronamespace = handler_fn_ns.oid
  )
  ON fdw.fdwhandler > 0 AND fdw.fdwhandler = handler_fn.oid
LEFT JOIN (
    pg_catalog.pg_proc AS validator_fn
    INNER JOIN pg_catalog.pg_namespace AS validator_fn_ns
      ON validator_fn.pronamespace = validator_fn_ns.oid
  )
  ON fdw.fdwvalidator > 0 AND fdw.fdwvalidator = validator_fn.oid
{{ end -}}