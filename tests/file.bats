#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/file.sh"
  temp_dir="$(temp_make)"
  temp_file="$(mktemp)"
}

@test "file_exists returns 0 for an existing regular file" {
  run file_exists "$temp_file"
  assert_success
}

@test "file_exists returns 1 for a non-existing file" {
  run file_exists "$temp_dir/non_existing_file.txt"
  assert_failure
}

@test "file_exists returns 1 for a directory" {
  run file_exists "$temp_dir"
  assert_failure
}

@test "file_exists returns 1 when argument is missing" {
  run file_exists
  assert_failure
}

@test "dir_exists returns 0 for an existing directory" {
  run dir_exists "$temp_dir"
  assert_success
}

@test "dir_exists returns 1 for a non-existing directory" {
  run dir_exists "$temp_dir/non_existing_dir"
  assert_failure
}

@test "dir_exists returns 1 for a regular file" {
  run dir_exists "$temp_file"
  assert_failure
}

@test "dir_exists returns 1 when argument is missing" {
  run dir_exists
  assert_failure
}

teardown() {
  temp_del "$temp_dir"
  rm -f "$temp_file"
}
