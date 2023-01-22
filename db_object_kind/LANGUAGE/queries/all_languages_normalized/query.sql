SELECT
  -- id, namespacing and ownership
    lang.oid
    , lang.lanname AS language_name
    , lang.lanowner AS owner_oid
    , lang.lanacl AS access_privileges -- aclitem[]
  -- details
    , lang.lanispl AS is_procedural
      -- This is false for internal languages (such as SQL) and true for
      -- user-defined languages.
    , lang.lanpltrusted AS is_trusted
      -- True if this is a trusted language, which means that it is believed not
      -- to grant access to anything outside the normal SQL execution environment.
      -- Only superusers can create functions in untrusted languages.

  -- Handler function details
    -- For noninternal languages this references the language handler, which is
    -- a special function that is responsible for executing all functions that
    -- are written in the particular language.
    , lang.lanplcallfoid AS handler_fn_oid
      -- zero if the language is internal
  -- inline block handler function details
    -- This references a function that is responsible for executing "inline"
    -- anonymous code blocks (DO blocks).
    , lang.laninline AS inline_block_handler_fn_oid
      -- Zero if inline blocks are not supported.

  -- validator function details
    -- This references a language validator function that is responsible for
    -- checking the syntax and validity of new functions when they are created.
    , lang.lanvalidator AS validator_fn_oid
      -- Zero if no validator is provided.
    , pg_catalog.obj_description(lang.oid, 'pg_language') AS "comment"
FROM pg_catalog.pg_language AS lang -- https://www.postgresql.org/docs/current/catalog-pg-language.html
