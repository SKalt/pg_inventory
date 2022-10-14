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

- [ ] [ACCESS_METHOD](./ACCESS_METHOD/)
- [ ] [AGGREGATE](./AGGREGATE/)
- [x] [CAST](./CAST/)
- [ ] [COLLATION](./COLLATION/)
- [x] [COLUMN](./COLUMN/README.md)
- [x] [CONSTRAINT](./CONSTRAINT/)
- [ ] [CONVERSION](./CONVERSION/)
- [x] [DATABASE](./DATABASE/)
- [ ] [DOMAIN](./DOMAIN/)
- [ ] [EVENT_TRIGGER](./EVENT_TRIGGER/)
- [ ] [EXTENSION](./EXTENSION/)
- [ ] [FOREIGN_DATA_WRAPPER](./FOREIGN_DATA_WRAPPER/)
- [x] [FOREIGN_TABLE](./FOREIGN_TABLE/)
- [x] [FUNCTION](./PROCEDURE/)
- [x] [INDEX](./INDEX/)
- [x] [LANGUAGE](./LANGUAGE/)
- [x] [MATERIALIZED_VIEW](./MATERIALIZED_VIEW/)
- [ ] [OPERATOR](./OPERATOR/)
- [ ] [OPERATOR_CLASS](./OPERATOR_CLASS/)
- [ ] [OPERATOR_FAMILY](./OPERATOR_FAMILY/)
- [ ] [POLICY](./POLICY/)
- [x] [PROCEDURE](./PROCEDURE/)
- [ ] [PUBLICATION](./PUBLICATION/)
- [x] [ROLE](./ROLE/)
- [ ] [RULE](./RULE/)
- [x] [SCHEMA](./SCHEMA/)
- [x] [SEQUENCE](./SEQUENCE/)
- [ ] [SERVER](./SERVER/)
- [ ] [STATISTICS](./STATISTICS/)
- [ ] [SUBSCRIPTION](./SUBSCRIPTION/)
- [x] [TABLE](./TABLE/)
- [x] [TABLESPACE](./TABLESPACE/)
- [ ] [TEXT_SEARCH_CONFIGURATION](./TEXT_SEARCH_CONFIGURATION/)
- [ ] [TEXT_SEARCH_DICTIONARY](./TEXT_SEARCH_DICTIONARY/)
- [ ] [TEXT_SEARCH_PARSER](./TEXT_SEARCH_PARSER/)
- [ ] [TEXT_SEARCH_TEMPLATE](./TEXT_SEARCH_TEMPLATE/)
- [ ] [TRANSFORM](./TRANSFORM/)
- [ ] [TRIGGER](./TRIGGER/)
- [x] [TYPE](./TYPE/)
- [ ] [USER_MAPPING](./USER_MAPPING/)
- [x] [VIEW](./VIEW/)
