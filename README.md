# pg_inventory

pg_catalog queries

This contains SQL long-form queries generated from Go templates.
Each SQL query is tested against a number of example databases.

### Directory structure

```
.
├── pkg
│   └── internal
│       └── test/*.go
├── scripts
│   ├── */*.go
│   └── *.sh
├── bin/*
├── sample_dbs/*.dump.sql
├── db_object_kinds/${kind}
│   ├── ${template_name}.sql.tpl
│   ├── ${template_name}.params.toml
│   └── ${query_name}
│        ├── query.sql
│        └── tests/${sample_db_name}/${test_case_name}
│            ├── params.toml
│            ├── explain.yaml
│            └── results.tsv
├── Makefile
└── README.md
```

### Database Object Kinds

- [x] [ACCESS_METHOD](./db_object_kind/ACCESS_METHOD/)
- [x] [AGGREGATE](./db_object_kind/AGGREGATE/) <!-- might be missing some function information? -->
- [x] [CAST](./db_object_kind/CAST/)
- [x] [COLLATION](./db_object_kind/COLLATION/)
- [x] [COLUMN](./db_object_kind/COLUMN/README.md)
- [x] [CONSTRAINT](./db_object_kind/CONSTRAINT/)
- [ ] [COMMENT](#)
- [x] [CONVERSION](./db_object_kind/CONVERSION/)
- [x] [DATABASE](./db_object_kind/DATABASE/)
- [x] [DOMAIN](./db_object_kind/TYPE/)
- [x] [ENUM](./db_object_kind/TYPE/)
- [x] [EVENT_TRIGGER](./db_object_kind/EVENT_TRIGGER/)
- [x] [EXTENSION](./db_object_kind/EXTENSION/)
- [x] [FOREIGN_DATA_WRAPPER](./db_object_kind/FOREIGN_DATA_WRAPPER/)
- [x] [FOREIGN_TABLE](./db_object_kind/FOREIGN_TABLE/)
- [x] [FUNCTION](./db_object_kind/PROCEDURE/)
- [x] [INDEX](./db_object_kind/INDEX/)
- [x] [LANGUAGE](./db_object_kind/LANGUAGE/)
- [x] [MATERIALIZED_VIEW](./db_object_kind/MATERIALIZED_VIEW/)
- [x] [OPERATOR](./db_object_kind/OPERATOR/)
- [x] [OPERATOR_CLASS](./db_object_kind/OPERATOR_CLASS/)
- [x] [OPERATOR_FAMILY](./db_object_kind/OPERATOR_FAMILY/)
- [x] [POLICY](./db_object_kind/POLICY/)
- [x] [PROCEDURE](./db_object_kind/PROCEDURE/)
- [ ] [PUBLICATION](./db_object_kind/PUBLICATION/) <!-- for replication -->
- [x] [ROLE](./db_object_kind/ROLE/)
- [x] [RULE](./db_object_kind/RULE/)
- [x] [SCHEMA](./db_object_kind/SCHEMA/)
- [x] [SEQUENCE](./db_object_kind/SEQUENCE/)
- [x] [SERVER](./db_object_kind/SERVER/)
- [ ] [STATISTICS](./db_object_kind/STATISTICS/)
- [ ] [SUBSCRIPTION](./db_object_kind/SUBSCRIPTION/) <!--  for replication -->
- [x] [TABLE](./db_object_kind/TABLE/)
- [x] [TABLESPACE](./db_object_kind/TABLESPACE/)
- [ ] [TEXT_SEARCH_CONFIGURATION](./db_object_kind/TEXT_SEARCH_CONFIGURATION/)
- [ ] [TEXT_SEARCH_DICTIONARY](./db_object_kind/TEXT_SEARCH_DICTIONARY/)
- [ ] [TEXT_SEARCH_PARSER](./db_object_kind/TEXT_SEARCH_PARSER/)
- [ ] [TEXT_SEARCH_TEMPLATE](./db_object_kind/TEXT_SEARCH_TEMPLATE/)
- [ ] [TRANSFORM](./db_object_kind/TRANSFORM/)
- [x] [TRIGGER](./db_object_kind/TRIGGER/)
- [x] [TYPE](./db_object_kind/TYPE/)
- [x] [USER_MAPPING](./db_object_kind/USER_MAPPING/)
- [x] [VIEW](./db_object_kind/VIEW/)
