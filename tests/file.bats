#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/file.sh"
  temp_dir="$(temp_make)"
  temp_file="$(mktemp)"
}

# Test: file_exists returns 0 for an existing regular file
@test "file_exists returns 0 for an existing regular file" {
  run file_exists "$temp_file"
  assert_success
}

# Test: file_exists returns 1 for a non-existing file
@test "file_exists returns 1 for a non-existing file" {
  run file_exists "$temp_dir/non_existing_file.txt"
  assert_failure
}

# Test: file_exists returns 1 for a directory
@test "file_exists returns 1 for a directory" {
  run file_exists "$temp_dir"
  assert_failure
}

# Test: file_exists returns 1 when argument is missing
@test "file_exists returns 1 when argument is missing" {
  run file_exists
  assert_failure
}

# Test: dir_exists returns 0 for an existing directory
@test "dir_exists returns 0 for an existing directory" {
  run dir_exists "$temp_dir"
  assert_success
}

# Test: dir_exists returns 1 for a non-existing directory
@test "dir_exists returns 1 for a non-existing directory" {
  run dir_exists "$temp_dir/non_existing_dir"
  assert_failure
}

# Test: dir_exists returns 1 for a regular file
@test "dir_exists returns 1 for a regular file" {
  run dir_exists "$temp_file"
  assert_failure
}

# Test: dir_exists returns 1 when argument is missing
@test "dir_exists returns 1 when argument is missing" {
  run dir_exists
  assert_failure
}

# Test: file_split splits a file into multiple parts
@test "file_split splits a file into multiple parts" {
  echo "line1" > "$temp_file"
  echo "line2" >> "$temp_file"
  echo "line3" >> "$temp_file"
  run file_split "$temp_file" "${temp_dir}/part" 2
  assert_success
  assert_file_exist "${temp_dir}/part01"
  assert_file_exist "${temp_dir}/part02"
}

# Test: file_split returns 1 for a non-existing file
@test "file_split returns 1 for a non-existing file" {
  run file_split "$temp_dir/non_existing_file.txt" 2
  assert_failure
}

# Test: file_split returns 1 when argument is missing
@test "file_split returns 1 when argument is missing" {
  run file_split
  assert_failure
}

teardown() {
  temp_del "$temp_dir"
  rm -f "$temp_file"
}
