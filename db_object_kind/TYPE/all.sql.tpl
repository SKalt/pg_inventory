{{- /* variable definitions*/ -}}
  {{- $show_all := (not .kind) -}}
  {{- $is_domain := (eq .kind "d") -}}
  {{- $is_composite := (eq .kind "c") -}}
  {{- $is_enum := (eq .kind "e") -}}
  {{- $show_domain := or $show_all $is_domain -}}
  {{- $show_composite := or $show_all $is_composite -}}
SELECT
-- namespacing and ownership
    ns.nspname AS type_schema_name
  , type_.typname AS type_name
  , type_.typlen AS byte_length -- int2
    -- for fixed-size types, the size of the internal representation of the type.
    -- for variable-length types, -1.
    -- for nulll-terminated c-strings, -2
  , type_owner.rolname AS type_owner_name
  , type_.typdefault AS default_value_expression
    -- human-readable text which can be fed to the type's input converter to
    -- produce a constant or null if the type has no associated default value.
  , type_.typacl AS access_privileges -- aclitem[]
-- misc type info
{{- if .packed }}
  , (/* info: a 2-byte packed struct of the form:
      1110 0000 0000 0000: kind
      0000 1111 0000 0000: category
      0000 0000 1100 0000: storage alignment
      0000 0000 0011 0000: storage type
      0001 0000 0000 1110: bools
      */
      0::INT2
      -- kind: 1110 0000 0000 0000
    {{- if $show_all }}
      | (
          CASE type_.typtype
            WHEN 'b' THEN 1 -- base
            WHEN 'c' THEN 2 -- composite
            WHEN 'd' THEN 3 -- domain
            WHEN 'e' THEN 4 -- enum
            WHEN 'p' THEN 5 -- pseudo
            WHEN 'r' THEN 6 -- range
            WHEN 'm' THEN 7 -- multi-range
          END
        )
    {{- else }} -- omitted
    {{- end }}
    {{- if $show_domain }}
      | CASE WHEN type_.typnotnull THEN 8 ELSE 0 END -- domain-only
    {{- end }}
      | (( -- category: 0000 1111 0000 0000
          CASE type_.typcategory
            WHEN 'A' THEN 0  -- Array
            WHEN 'B' THEN 1  -- Boolean
            WHEN 'C' THEN 2  -- Composite
            WHEN 'D' THEN 3  -- Date/time
            WHEN 'E' THEN 4  -- Enum
            WHEN 'G' THEN 5  -- Geometric
            WHEN 'I' THEN 6  -- Network address
            WHEN 'N' THEN 7  -- Numeric
            WHEN 'P' THEN 8  -- Pseudo-types
            WHEN 'R' THEN 9  -- Range
            WHEN 'S' THEN 10 -- String
            WHEN 'T' THEN 11 -- Timespan
            WHEN 'U' THEN 12 -- User-defined
            WHEN 'V' THEN 13 -- Bit-string
            WHEN 'X' THEN 14 -- unknown
          END
        )<<4)
      | (( -- storage alignment: 0000 0000 1100 0000
          CASE type_.typalign
            WHEN 'c' THEN 0-- char alignment, i.e., no alignment needed.
            WHEN 's' THEN 1 -- short alignment (2 bytes on most machines).
            WHEN 'i' THEN 2 -- int alignment (4 bytes on most machines).
            WHEN 'd' THEN 3 -- double alignment (8 bytes on many machines, but by no means all).
          END
        )<<8)
      | (( -- storage code: 0000 0000 0011 0000
          -- for varlena types (those with typlen = -1), whether the type is prepared
          -- for TOASTing and what the default strategy for attributes of this type
          -- should be. Possible values are:
          CASE type_.typstorage
            WHEN 'p' THEN 0
              --  plain: Values must always be stored plain (non-varlena types
              --  always use this value).
            WHEN 'e' THEN 1
              --  external: Values can be stored in a secondary “TOAST” relation (
              --  f relation has one, see pg_class.reltoastrelid).
            WHEN 'm' THEN 2 --  main: Values can be compressed and stored inline.
            WHEN 'x' THEN 3
              --  extended: Values can be compressed and/or moved to a secondary
              --  relation.
          END
        )<<10)
    -- bools: 0001 0000 0000 1110
      | CASE WHEN type_.typbyval       THEN 1<<12 ELSE 0 END
      | CASE WHEN type_.typispreferred THEN 1<<13 ELSE 0 END
        -- bool: preferred cast target in type catagory
      | CASE WHEN type_.typisdefined   THEN 1<<14 ELSE 0 END
        -- if false, a placeholder for a TBD (to-be-defined) type. If false, only
        -- type_name, type_schema, type_oid are valid
    )::INT2 AS info
{{- else }}
  {{- if $show_all }}
  , type_.typtype AS type_kind
    -- could be compressed to 3 bits?
    -- 'b' => base
    -- 'c' => composite
    -- 'd' => domain
    -- 'e' => enum
    -- 'p' => pseudo
    -- 'r' => range
    -- 'm' => multi-range
  {{- end }}
  , type_.typcategory AS type_category -- char
    -- 'A' => Array
    -- 'B' => Boolean
    -- 'C' => Composite
    -- 'D' => Date/time
    -- 'E' => Enum
    -- 'G' => Geometric
    -- 'I' => Network address
    -- 'N' => Numeric
    -- 'P' => Pseudo-types
    -- 'R' => Range
    -- 'S' => String
    -- 'T' => Timespan
    -- 'U' => User-defined
    -- 'V' => Bit-string
    -- 'X' => unknown
  , type_.typbyval AS pass_by_value -- bool; alternative being pass_by_reference
  {{- if $show_domain }}
  , type_.typnotnull AS not_null -- bool: constraint for domains
  {{- end }}
  , type_.typalign AS storage_alignment_code
    -- c => char alignment, i.e., no alignment needed.
    -- s => short alignment (2 bytes on most machines).
    -- i => int alignment (4 bytes on most machines).
    -- d => double alignment (8 bytes on many machines, but by no means all).
  , type_.typstorage AS storage_kind
    -- for varlena types (those with typlen = -1), whether the type is prepared
    -- for TOASTing and what the default strategy for attributes of this type
    -- should be. Possible values are:
    --   p => plain: Values must always be stored plain (non-varlena types
    --        always use this value).
    --   e => external: Values can be stored in a secondary “TOAST” relation (
    --        f relation has one, see pg_class.reltoastrelid).
    --   m => main: Values can be compressed and stored inline.
    --   x => extended: Values can be compressed and/or moved to a secondary
    --        relation.
  , type_.typispreferred AS is_preferred
    -- bool: preferred cast target in type catagory
  , type_.typisdefined AS is_defined
    -- if false, a placeholder for a TBD (to-be-defined) type. If false, only
    -- type_name, type_schema, type_oid are valid
{{ end }}
-- array handling
  , type_.typdelim AS delimiter_character
    -- 1-byte char that separates two values of this type when parsing array input
    -- associate with array *element* type, not array-type

  , subscripting_fn_schema.nspname AS subscripting_handler_fn_schema
  , subscripting_fn.proname AS subscripting_handler_fn
    -- null if this type doesn't support subscripting
  , element_type_schema.nspname AS element_type_schema
  , element_type.typname AS element_type
    -- if nonzero, then element_type_oid references pg_type.oid to define the element type
    -- of this type.
    -- Can be zero when subscripting_handler_fn_oid is defined if the subscript-hander
    -- already knows what the element type is.
    -- A element_type_oid dependency is considered to imply physical containment of the
    -- element type in this type; so DDL changes on the element type might be restricted
    -- by the presence of this type.
  , type_.typndims AS domain_array_dimensions
    -- number of array dimensions for a domain over an array, 0 for all others.
  , collation_schema.nspname AS collation_schema
  , collation_.collname AS "collation"
    -- references pg_collation.oid if the type supports collations, else 0
  , array_type_schema.nspname AS array_type_schema
  , array_type.typname AS array_type
  -- if nonzero, references the "true" array type with this type as the element
  -- type.

-- related functions
  , text_conversion_input_fn_schema.nspname AS text_conversion_input_fn_schema
  , text_conversion_input_fn.proname AS text_conversion_input_fn
  , text_conversion_output_fn_schema.nspname AS text_conversion_output_fn_schema
  , text_conversion_output_fn.proname AS text_conversion_output_fn
  , binary_conversion_input_fn_schema.nspname AS binary_conversion_input_fn_schema
  , binary_conversion_input_fn.proname AS binary_conversion_input_fn -- zero if none
  , binary_conversion_output_fn_schema.nspname AS binary_conversion_output_fn_schema
  , binary_conversion_output_fn.proname AS binary_conversion_output_fn -- zero if none
  , type_modifier_input_fn_schema.nspname AS type_modifier_input_fn_schema
  , type_modifier_input_fn.proname AS type_modifier_input_fn
    -- zero of this type doesn't support modifiers
  , type_modifier_output_fn_schema.nspname AS type_modifier_output_fn_schema
  , type_modifier_output_fn.proname AS type_modifier_output_fn
  , custom_analyze_fn_schema.nspname AS custom_analyze_fn_schema
  , custom_analyze_fn.proname AS custom_analyze_fn
    -- zero if default analyze used

{{- if $show_composite }}
  , relation.relname AS relation_name
    -- only for composite types.
{{- end }}
{{- if $show_domain }}
  -- TODO: join for base_type schema
  , base_type.typname AS base_type_name
  , pg_catalog.pg_get_userbyid(base_type.typowner) AS base_type_owner
  , type_.typtypmod AS base_type_mod -- ???
    -- the typmod to be applied to this domain's base type
    -- -1 if the base type does not use a typmod or if this type is not a domain.
  -- TODO: consider returning type_.typdefaultbin?
  , pg_catalog.format_type(type_.oid, type_.typtypmod) AS formatted
{{- end }}
{{- if $is_enum }}
, ARRAY((
    SELECT enumlabel
    FROM pg_catalog.pg_enum
    WHERE enumtypid = type_.oid
    ORDER BY enumsortorder
  )) AS enum_items
{{- end}}
FROM pg_catalog.pg_type AS type_ --https://www.postgresql.org/docs/current/catalog-pg-type.html
INNER JOIN pg_catalog.pg_namespace AS ns -- https://www.postgresql.org/docs/current/catalog-pg-namespace.html
  ON {{- if .kind }} type_.typtype = '{{.kind}}' AND
  {{- end }} type_.typnamespace = ns.oid
INNER JOIN pg_catalog.pg_authid AS type_owner -- https://www.postgresql.org/docs/current/catalog-pg-authid.html
  ON type_.typowner = type_owner.oid
{{ if $show_composite -}}
  {{- if $is_composite -}}
    INNER
  {{- else -}}
    LEFT
  {{- end }} JOIN pg_catalog.pg_class AS relation -- https://www.postgresql.org/docs/current/catalog-pg-class.html
  ON {{ if not $is_composite -}} type_.typrelid > 0 AND {{ end -}} type_.typrelid = relation.oid
  -- TODO: join pg_catalog.pg_namespace for relation_schema_name, oid
{{- end }}
{{ if $show_domain -}}
  {{- if $is_domain -}} INNER {{- else -}} LEFT {{- end }} JOIN pg_catalog.pg_type AS base_type
  ON {{ if not $is_domain -}} type_.typbasetype > 0 AND {{ end -}} type_.typbasetype = base_type.oid
{{- end }}

LEFT JOIN (
  pg_catalog.pg_proc AS subscripting_fn
  INNER JOIN pg_catalog.pg_namespace AS subscripting_fn_schema
    ON subscripting_fn.pronamespace = subscripting_fn_schema.oid
) ON type_.typsubscript = subscripting_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS text_conversion_input_fn
  INNER JOIN pg_catalog.pg_namespace AS text_conversion_input_fn_schema
    ON text_conversion_input_fn.pronamespace = text_conversion_input_fn_schema.oid
) ON type_.typinput = text_conversion_input_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS text_conversion_output_fn
  INNER JOIN pg_catalog.pg_namespace AS text_conversion_output_fn_schema
    ON text_conversion_output_fn.pronamespace = text_conversion_output_fn_schema.oid
) ON type_.typoutput = text_conversion_output_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS binary_conversion_input_fn
  INNER JOIN pg_catalog.pg_namespace AS binary_conversion_input_fn_schema
    ON binary_conversion_input_fn.pronamespace = binary_conversion_input_fn_schema.oid
) ON type_.typreceive = binary_conversion_input_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS binary_conversion_output_fn
  INNER JOIN pg_catalog.pg_namespace AS binary_conversion_output_fn_schema
    ON binary_conversion_output_fn.pronamespace = binary_conversion_output_fn_schema.oid
) ON type_.typsend = binary_conversion_output_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS type_modifier_input_fn
  INNER JOIN pg_catalog.pg_namespace AS type_modifier_input_fn_schema
    ON type_modifier_input_fn.pronamespace = type_modifier_input_fn_schema.oid
) ON type_.typmodin = type_modifier_input_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS type_modifier_output_fn
  INNER JOIN pg_catalog.pg_namespace AS type_modifier_output_fn_schema
    ON type_modifier_output_fn.pronamespace = type_modifier_output_fn_schema.oid
) ON type_.typmodout = type_modifier_output_fn.oid

LEFT JOIN (
  pg_catalog.pg_proc AS custom_analyze_fn
  INNER JOIN pg_catalog.pg_namespace AS custom_analyze_fn_schema
    ON custom_analyze_fn.pronamespace = custom_analyze_fn_schema.oid
) ON type_.typanalyze = custom_analyze_fn.oid

LEFT JOIN (
  pg_catalog.pg_collation AS collation_
  INNER JOIN pg_catalog.pg_namespace AS collation_schema
    ON collation_.collnamespace = collation_schema.oid
) ON type_.typcollation = collation_.oid

LEFT JOIN (
  pg_catalog.pg_type AS array_type
  INNER JOIN pg_catalog.pg_namespace AS array_type_schema
    ON array_type.typnamespace = array_type_schema.oid
) ON type_.typarray = array_type.oid

LEFT JOIN (
  pg_catalog.pg_type AS element_type
  INNER JOIN pg_catalog.pg_namespace AS element_type_schema
    ON element_type.typnamespace = element_type_schema.oid
) ON type_.typelem = element_type.oid