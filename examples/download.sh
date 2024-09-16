#!/usr/bin/env bash

set -eu

source "${BASH_SOURCE[0]%/*}/../utils.sh"

main() {
  log.notice "downloading different image formats"
  download "https://httpbin.org/image/{jpeg,png,svg}" "image.#1"
}

main
