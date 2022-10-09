#!/bin/sh
url=https://github.com/loeffel-io/ls-lint/releases/download/v1.11.2/ls-lint-linux
curl -sL -o bin/ls-lint "$url" &&
  chmod +x ./bin/ls-lint