#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR/../lib/utils.sh"

main() {
  log.notice "test http get"
  http.get "https://httpbin.org/get"
}

main
