#!/usr/bin/env bash
### USAGE: ./find_test_deps.sh TSV_PATH
### find the


id_db_dump(){
  case "$1" in
  adventureworks|airflow|chinook|clubdata|covid|northwind|omnibus|polls|retail_analytics|sakila|sportsdb) ;;
  *) echo "unknown db: $1" >&2; return 1;;
  esac
  echo "sample_dbs/$1.schema.dump.sql"
}

main() {
  set -euo pipefail
  local target="$1"
  if [[ "$target" != */results.tsv ]]; then echo "not */results.tsv">&2; fi
  # pattern is db_object_kind/${kind}/queries/${query_name}/tests/${db}/${test_name}/results.tsv

  dir="$(dirname "$target")"
  [ -f "$dir/params.toml" ] && echo "$dir/params.toml"

  # db_object_kind/${kind}/queries/${query_name}/tests/${db}/${test_name}
  # test_name="$(basename "$dir")"
  dir="$(dirname "$dir")"
  # db_object_kind/${kind}/queries/${query_name}/tests/${db}
  db_name="$(basename "$dir")"
  dir="$(dirname "$dir")"
  # db_object_kind/${kind}/queries/${query_name}/tests
  dir="$(dirname "$dir")"
  # db_object_kind/${kind}/queries/${query_name}
  # query_name="$(basename "$dir")"

  echo "./sample_dbs/$db_name.dump.sql"
  echo "$dir/query.sql"
}

if [ "${BASH_SOURCE[0]}" = "$0" ]; then main "$@"; fi
