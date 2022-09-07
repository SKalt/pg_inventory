.PHONY: all
all: ./db_object_kind/SCHEMA/queries/all_schemata/query.sql

bin/render_template: ./scripts/render_template/*.go go.mod go.sum
	@go build -o ./bin/render_template ./scripts/render_template
bin/test_query: ./scripts/test_query/*.go go.mod go.sum
	@go build -o ./bin/test_query ./scripts/test_query
test: bin/test_query ./db_object_kind/SCHEMA/queries/all_schemata/query.sql
	@./bin/test_query ./db_object_kind/SCHEMA/queries/all_schemata/tests/empty/should_have_internal_schemata_only

./db_object_kind/SCHEMA/queries/all_schemata/query.sql ./db_object_kind/SCHEMA/queries/all_schemata_named_like/query.sql ./db_object_kind/SCHEMA/queries/all_schemata_excluding_internal_named_like/query.sql ./db_object_kind/SCHEMA/queries/all_schemata_excluding_internal/query.sql ./db_object_kind/SCHEMA/queries/single_schema_named/query.sql &: \
	bin/render_template \
	./db_object_kind/SCHEMA/schema.sql.tpl \
	./db_object_kind/SCHEMA/schema.params.toml
	@bin/render_template -t ./db_object_kind/SCHEMA/schema.sql.tpl

.PHONY: ls-lint
ls-lint: bin/ls-lint .ls-lint.yml
	@bin/ls-lint
bin/ls-lint: ./scripts/dev_env/install_ls_lint.sh
	@./scripts/dev_env/install_ls_lint.sh