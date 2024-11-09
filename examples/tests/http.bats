#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../http.sh"
}

# Test: http example should return 0
@test "http example should return 0" {
  run main
  assert_success
  assert_output --partial '"url": "https://httpbin.org/get"'
}
