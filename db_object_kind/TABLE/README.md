orthogonal axes:
- relations:
  - schema filter
    - single, with oid
    - single, with name
    - 0-many, in oids
    - 0-many, in names
    - 0-many, named like
    - all schemata
  - table filter
    - with oid
    - in oids
    - named like
    - all
  - relkind
    - r = ordinary table
    <!-- - i = index -->
    <!-- - S = sequence -->
    - t = TOAST table
    <!-- - v = view -->
    <!-- - m = materialized view -->
    <!-- - c = composite type -->
    <!-- - f = foreign table -->
    - p = partitioned table
    <!-- - I = partitioned index -->
  - relpersistence
    - p = permanent table
    - u = unlogged table
    - t = temporary table
  - relispartition (=> relpartbound)

ALSO: pack bools into a SMALLINT!

relationships:
- typed tables => type
-


    - r = ordinary table
    - i = index


- [ ] [all tables in a single schema](./)
- [ ] [all tables](./)
- [ ] [all tables in schemas named like](./)
- [ ] [all tables in all schemata](./)
- [ ] [all tables in all schemata named like](./)

- [ ] [all partitioned tables](./)
- [ ] [all partitions of a given table](./)
- [ ] [all partition relationships](./)
- [ ] [all inheritance relationships](./)

- [ ] [comments on a table with a given oid](./comments_on_table_with_oid.sql)
- [ ] [comments on tables with oids in a given set of oids](./comments_on_tables_with_oids.sql)

<!-- bonus -->
- [ ] all tables owned by an extension
