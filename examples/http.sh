#!/usr/bin/env bash

set -eu

SCRIPTDIR=${BASH_SOURCE[0]%/*}

. "$SCRIPTDIR/../lib/utils.sh"

main() {
  log.notice "test http get"
  http.get "https://httpbin.org/get"
}

main
