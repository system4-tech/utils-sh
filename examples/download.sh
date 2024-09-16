#!/usr/bin/env bash

set -e

source <(curl -fsSL https://raw.githubusercontent.com/system4-tech/utils-sh/main/utils.shh)

main() {
  log.notice "downloading different image formats"
  download "https://httpbin.org/image/{jpeg,png,svg}" "image.#1"
}

main
