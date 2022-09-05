.PHONY: sample-db-dumps
sample-db-dumps: sample_dbs/omnibus.dump.sql
sample_dbs/omnibus.dump.sql:
	./scripts/refresh_sample_databases.sh

