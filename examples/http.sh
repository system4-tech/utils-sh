#!/usr/bin/env bash

set -e

source <(curl -fsSL https://raw.githubusercontent.com/system4-tech/utils-sh/main/utils.sh)

main() {
  log.notice "test http get"
  http.get "https://httpbin.org/get"
}

main
