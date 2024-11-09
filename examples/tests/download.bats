#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../download.sh"
  temp_dir="$(temp_make)"
}

# Test: download example should return 0
@test "download example should return 0" {
  run main
  assert_success
  # Check if png and jpeg files are present in the output, regardless of order
  assert_line "image.png"
  assert_line "image.jpeg"
}

teardown() {
  temp_del "$temp_dir"
}
