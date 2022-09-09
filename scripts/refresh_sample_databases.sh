#!/bin/bash
repo="skalt/postgres_sample_dbs"
url="https://api.github.com/repos/$repo/releases/latest"
curl -s $url |
 grep browser_download_url |
  grep all_schema_dumps |
  awk -F '"' '{ print $4 }' |
  xargs curl -sL > /tmp/all_schema_dumps.tar.gz
rm -rf ./sample_dbs && mkdir ./sample_dbs
tar -xf /tmp/all_schema_dumps.tar.gz -C ./sample_dbs

