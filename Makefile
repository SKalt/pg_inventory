.PHONY: all ls-lint

ls-lint: bin/ls-lint .ls-lint.yml
	@bin/ls-lint
bin/ls-lint: ./scripts/dev_env/install_ls_lint.sh
	@./scripts/dev_env/install_ls_lint.sh
bin/render_template: ./scripts/render_template/*.go go.mod go.sum
	@go build -o ./bin/render_template ./scripts/render_template
bin/test_query: ./scripts/test_query/*.go go.mod go.sum
	@go build -o ./bin/test_query ./scripts/test_query

# all_sample_dbs=\
# 	adventureworks\
# 	airflow\s
# 	chinook\
# 	clubdata\
# 	covid\
# 	northwind\
# 	omnibus\
# 	polls\
# 	retail_analytics\
# 	sakila\
# 	sportsdb\
################################################################################
schema=db_object_kind/SCHEMA/queries
schema_queries=./${schema}/all_schemata/query.sql \
	./${schema}/all_schemata_named_like/query.sql \
	./${schema}/all_schemata_excluding_internal_named_like/query.sql \
	./${schema}/all_schemata_excluding_internal/query.sql \
	./${schema}/single_schema_named/query.sql \

.PHONY: schema-queries
schema-queries: ${schema_queries}
${schema_queries} &: \
	bin/render_template \
	./db_object_kind/SCHEMA/schema.sql.tpl \
	./db_object_kind/SCHEMA/schema.params.toml \

	@bin/render_template -t ./db_object_kind/SCHEMA/schema.sql.tpl
# ------------------------------------------------------------------------------
all_schema_tests=\
	${schema}/all_schemata/tests/empty/should_have_internal_schemata_only/results.tsv\
	${schema}/all_schemata/tests/sakila/expected/results.tsv\
	${schema}/all_schemata/tests/omnibus/expected/results.tsv\

${schema}/all_schemata/tests/empty/should_have_internal_schemata_only/results.tsv: \
	bin/test_query \
	${schema}/all_schemata/query.sql \

	@bin/test_query $(shell dirname $@)

${schema}/all_schemata/tests/sakila/expected/results.tsv: \
	bin/test_query \
	${schema}/all_schemata/query.sql \
	sample_dbs/sakila.schema.dump.sql \

	@bin/test_query $(shell dirname $@) && touch -m "$@"

${schema}/all_schemata/tests/omnibus/expected/results.tsv: \
	bin/test_query \
	${schema}/all_schemata/query.sql \
	sample_dbs/omnibus.schema.dump.sql \

	@bin/test_query $(shell dirname $@) && touch -m "$@"

# ------------------------------------------------------------------------------
${schema}/all_schemata_excluding_internal/tests/empty/expected/results.tsv: \
	bin/test_query \
	${schema}/all_schemata/query.sql \

	@bin/test_query $(shell dirname $@) && touch -m $@

${schema}/all_schemata_excluding_internal/tests/omnibus/expected/results.tsv: \
	bin/test_query \
	${schema}/all_schemata_excluding_internal/query.sql \
	sample_dbs/omnibus.schema.dump.sql \

	@bin/test_query $(shell dirname $@) && touch -m $@

${schema}/all_schemata_excluding_internal/tests/sakila/expected/results.tsv: \
	bin/test_query \
	${schema}/all_schemata_excluding_internal/query.sql \
	sample_dbs/sakila.schema.dump.sql \

	@bin/test_query $(shell dirname $@) && touch -m $@
################################################################################
role=db_object_kind/ROLE/queries
all_role_tests=\
	${role}/all_roles/tests/empty/superuser_only/results.tsv \
	${role}/all_roles/tests/sakila/superuser_only/results.tsv \
	${role}/all_roles/tests/omnibus/mishmash/results.tsv \

${role}/all_roles/tests/empty/superuser_only/results.tsv: \
	${role}/all_roles/query.sql \
	bin/test_query \

	@bin/test_query $(shell dirname $@) && touch -m $@

${role}/all_roles/tests/sakila/superuser_only/results.tsv: \
	${role}/all_roles/query.sql \
	sample_dbs/sakila.schema.dump.sql \
	bin/test_query \

	@bin/test_query $(shell dirname $@) && touch -m $@

${role}/all_roles/tests/omnibus/mishmash/results.tsv: \
	${role}/all_roles/query.sql \
	sample_dbs/omnibus.schema.dump.sql \
	bin/test_query \

	@bin/test_query $(shell dirname $@) && touch -m $@
################################################################################
all_queries=\
	${schema_queries}\

all_tests=\
	${all_schema_tests}\

.PHONY: tests
tests: \
	${all_tests} \
	${all_role_tests}

all: ${all_queries} ${all_tests}
