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
- [ ] [CAST](./CAST/)
- [ ] [COLLATION](./COLLATION/)
- [ ] [COLUMN](./COLUMN/)
- [ ] [CONSTRAINT](./CONSTRAINT/)
- [ ] [CONVERSION](./CONVERSION/)
- [x] [DATABASE](./DATABASE/)
- [ ] [DOMAIN](./DOMAIN/)
- [ ] [EVENT_TRIGGER](./EVENT_TRIGGER/)
- [ ] [EXTENSION](./EXTENSION/)
- [ ] [FOREIGN_DATA_WRAPPER](./FOREIGN_DATA_WRAPPER/)
- [ ] [FOREIGN_TABLE](./FOREIGN_TABLE/)
- [ ] [FUNCTION](./FUNCTION/)
- [ ] [GROUP](./GROUP/)
- [ ] [INDEX](./INDEX/)
- [ ] [LANGUAGE](./LANGUAGE/)
- [ ] [MATERIALIZED_VIEW](./MATERIALIZED_VIEW/)
- [ ] [OPERATOR](./OPERATOR/)
- [ ] [OPERATOR_CLASS](./OPERATOR_CLASS/)
- [ ] [OPERATOR_FAMILY](./OPERATOR_FAMILY/)
- [ ] [POLICY](./POLICY/)
- [ ] [PROCEDURE](./PROCEDURE/)
- [ ] [PUBLICATION](./PUBLICATION/)
- [X] [ROLE](./ROLE/)
- [ ] [RULE](./RULE/)
- [x] [SCHEMA](./SCHEMA/)
- [ ] [SEQUENCE](./SEQUENCE/)
- [ ] [SERVER](./SERVER/)
- [ ] [STATISTICS](./STATISTICS/)
- [ ] [SUBSCRIPTION](./SUBSCRIPTION/)
- [X] [TABLE](./TABLE/)
- [ ] [TABLESPACE](./TABLESPACE/)
- [ ] [TEXT_SEARCH_CONFIGURATION](./TEXT_SEARCH_CONFIGURATION/)
- [ ] [TEXT_SEARCH_DICTIONARY](./TEXT_SEARCH_DICTIONARY/)
- [ ] [TEXT_SEARCH_PARSER](./TEXT_SEARCH_PARSER/)
- [ ] [TEXT_SEARCH_TEMPLATE](./TEXT_SEARCH_TEMPLATE/)
- [ ] [TRANSFORM](./TRANSFORM/)
- [ ] [TRIGGER](./TRIGGER/)
- [ ] [TYPE](./TYPE/)
- [ ] [USER](./USER/)
- [ ] [USER_MAPPING](./USER_MAPPING/)
- [ ] [VIEW](./VIEW/)
