{{- $include_external := not (eq .internal "only") -}}
SELECT
  -- id, namespacing and ownership
    {{ if .oid -}} lang.oid
    , {{ end -}} lang.lanname AS language_name
    {{- if .oid }}
    , lang.lanowner AS owner_oid
    {{- else }}
    , pg_catalog.pg_get_userbyid(lang.lanowner) AS owner_name
    {{- end }}
    , lang.lanacl AS access_privileges -- aclitem[]
  -- details
    {{if eq .internal "only" -}} -- omitted for internal languages: {{ end -}}
    , lang.lanispl AS is_procedural
      -- This is false for internal languages (such as SQL) and true for
      -- user-defined languages.
    , lang.lanpltrusted AS is_trusted
      -- True if this is a trusted language, which means that it is believed not
      -- to grant access to anything outside the normal SQL execution environment.
      -- Only superusers can create functions in untrusted languages.

  -- Handler function details
  {{- if eq .internal "only" }} -- excluded for internal languages
  {{- else }}
    -- For noninternal languages this references the language handler, which is
    -- a special function that is responsible for executing all functions that
    -- are written in the particular language.
    {{- if .oid }}
    , lang.lanplcallfoid AS handler_fn_oid
      -- zero if the language is internal
    {{- else }}
    , handler_fn_ns.nspname AS handler_fn_schema_name
    , handler_fn.proname AS handler_fn_name
    , pg_catalog.pg_get_userbyid(handler_fn.proowner) AS handler_fn_owner
    {{- end }}
  {{- end }}
  -- inline block handler function details
  {{- if eq .internal "only" }} -- excluded for internal languages
  {{- else }}
    -- This references a function that is responsible for executing "inline"
    -- anonymous code blocks (DO blocks).
    {{- if .oid }}
    , lang.laninline AS inline_block_handler_fn_oid
      -- Zero if inline blocks are not supported.
    {{- else }}
    , inline_block_handler_fn_ns.nspname AS inline_block_handler_fn_schema_name
    , inline_block_handler_fn.proname AS inline_block_handler_fn_name
    , pg_catalog.pg_get_userbyid(inline_block_handler_fn.proowner) AS inline_block_handler_fn_owner
    {{- end }}
  {{- end }}

  -- validator function details
    -- This references a language validator function that is responsible for
    -- checking the syntax and validity of new functions when they are created.
  {{- if eq .internal "only" }} -- excluded for internal languages
  {{- else }}
    {{- if .oid }}
    , lang.lanvalidator AS validator_fn_oid
      -- Zero if no validator is provided.
    {{- else }}
    , validator_fn_ns.nspname AS validator_fn_schema_name
    , validator_fn.proname AS validator_fn_name
    , pg_catalog.pg_get_userbyid(validator_fn.proowner) AS validator_fn_owner
    {{- end }}
  {{- end }}
    , pg_catalog.obj_description(lang.oid, 'pg_language') AS "comment"
FROM pg_catalog.pg_language AS lang -- https://www.postgresql.org/docs/current/catalog-pg-language.html
{{ if not .oid -}}
LEFT JOIN (
    pg_catalog.pg_proc AS handler_fn -- -- https://www.postgresql.org/docs/current/catalog-pg-proc.html
    INNER JOIN pg_catalog.pg_namespace AS handler_fn_ns
      ON handler_fn.pronamespace = handler_fn_ns.oid
  )
  ON lang.lanplcallfoid > 0 AND lang.lanplcallfoid = handler_fn.oid
LEFT JOIN (
    pg_catalog.pg_proc AS inline_block_handler_fn
    INNER JOIN pg_catalog.pg_namespace AS inline_block_handler_fn_ns
      ON inline_block_handler_fn.pronamespace = inline_block_handler_fn_ns.oid
  ) ON lang.laninline > 0 AND lang.laninline = inline_block_handler_fn.oid
LEFT JOIN (
    pg_catalog.pg_proc AS validator_fn
    INNER JOIN pg_catalog.pg_namespace AS validator_fn_ns
      ON validator_fn.pronamespace = validator_fn.oid
  ) ON lang.lanvalidator > 0 AND lang.lanvalidator = validator_fn.oid
{{ end -}}
