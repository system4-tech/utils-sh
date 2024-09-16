#!/usr/bin/env bash

set -eu

source "${BASH_SOURCE[0]%/*}/../utils.sh"

main() {
  log.notice "test http get"
  http.get "https://httpbin.org/get"
}

main
