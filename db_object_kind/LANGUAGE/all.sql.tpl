SELECT
    lang.lanname AS language_name

  , lang_owner.rolname AS owner_name
  , lang.lanispl AS is_procedural
    -- This is false for internal languages (such as SQL) and true for
    -- user-defined languages.
  , lang.lanpltrusted AS is_trusted
    -- True if this is a trusted language, which means that it is believed not
    -- to grant access to anything outside the normal SQL execution environment.
    -- Only superusers can create functions in untrusted languages.
  , pg_catalog.pg_get_userbyid(handler_fn.proowner) AS handler_fn_owner
  , lang.lanacl AS access_privileges -- aclitem[]

  , handler_fn_ns.nspname AS handler_fn_schema_name
  , handler_fn.proname AS handler_fn_name
    -- For noninternal languages this references the language handler, which is
    -- a special function that is responsible for executing all functions that
    -- are written in the particular language. Zero for internal languages.

  , inline_block_handler_fn_ns.nspname AS inline_block_handler_fn_schema_name
  , inline_block_handler_fn.proname AS inline_block_handler_fn_name
    -- This references a function that is responsible for executing "inline"
    -- anonymous code blocks (DO blocks). Zero if inline blocks are not supported.
  , pg_catalog.pg_get_userbyid(inline_block_handler_fn.proowner) AS inline_block_handler_fn_owner

  , validator_fn_ns.nspname AS validator_fn_schema_name
  , validator_fn.proname AS validator_fn_name
    -- This references a language validator function that is responsible for
    -- checking the syntax and validity of new functions when they are created.
    -- Zero if no validator is provided.
  , pg_catalog.pg_get_userbyid(validator_fn.proowner) AS validator_fn_owner
FROM pg_catalog.pg_language AS lang -- https://www.postgresql.org/docs/current/catalog-pg-language.html
LEFT JOIN (
    pg_catalog.pg_proc AS handler_fn -- -- https://www.postgresql.org/docs/current/catalog-pg-proc.html
    INNER JOIN pg_catalog.pg_namespace AS handler_fn_ns
      ON handler_fn.pronamespace = handler_fn_ns.oid
  )
  ON lang.lanplcallfoid > 0 AND lang.lanplcallfoid = handler_fn.oid
INNER JOIN pg_catalog.pg_authid AS lang_owner -- https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON
  {{- if (eq .internal "exclude") }}
    lang.lanispl AND
  {{ else if (eq .internal "only") }}
    lang.lanispl = false AND
  {{- end }}
  lang.lanowner = lang_owner.oid
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
