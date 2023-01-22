SELECT
  -- id, namespacing and ownership
    lang.oid
    , lang.lanname AS language_name
    , lang.lanowner AS owner_oid
    , lang.lanacl AS access_privileges -- aclitem[]
  -- details
    -- omitted for internal languages:lang.lanispl AS is_procedural
      -- This is false for internal languages (such as SQL) and true for
      -- user-defined languages.
    , lang.lanpltrusted AS is_trusted
      -- True if this is a trusted language, which means that it is believed not
      -- to grant access to anything outside the normal SQL execution environment.
      -- Only superusers can create functions in untrusted languages.

  -- Handler function details -- excluded for internal languages
  -- inline block handler function details -- excluded for internal languages

  -- validator function details
    -- This references a language validator function that is responsible for
    -- checking the syntax and validity of new functions when they are created. -- excluded for internal languages
FROM pg_catalog.pg_language AS lang -- https://www.postgresql.org/docs/current/catalog-pg-language.html
