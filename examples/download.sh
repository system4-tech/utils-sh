#!/usr/bin/env bash

set -eu

SCRIPTDIR=${BASH_SOURCE[0]%/*}

. "$SCRIPTDIR/../lib/utils.sh"

main() {
  log.notice "downloading different image formats"
  download "https://httpbin.org/image/{jpeg,png,svg}" "image.#1"
}

main
