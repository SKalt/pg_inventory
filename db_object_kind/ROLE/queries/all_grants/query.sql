SELECT
    pg_catalog.pg_get_userbyid(roleid)  AS parent_role
  , pg_catalog.pg_get_userbyid(member)  AS child_role
  , pg_catalog.pg_get_userbyid(grantor) AS grantor_role
  , admin_option AS member_can_also_grant_membership
FROM pg_catalog.pg_auth_members-- see https://www.postgresql.org/docs/current/catalog-pg-auth-members.html
