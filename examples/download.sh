#!/usr/bin/env bash

set -eu

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

. "$SCRIPT_DIR/../lib/utils.sh"

main() {
  log.notice "downloading different image formats"
  download "https://httpbin.org/image/{jpeg,png,svg}" "image.#1"
}

main
