#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/helpers.sh"
}

# Test: is_set should return 0 for a non-empty string
@test "is_set returns 0 for a non-empty string" {
  run is_set "Hello"
  assert_success
}

# Test: is_set should return 1 for an empty string
@test "is_set returns 1 for an empty string" {
  run is_set ""
  assert_failure
}

# Test: is_set should return 1 when no argument is provided
@test "is_set returns 1 when no argument is provided" {
  run is_set
  assert_failure
}

# Test: is_empty should return 0 for an empty string
@test "is_empty returns 0 for an empty string" {
  run is_empty ""
  assert_success
}

# Test: is_empty should return 1 for a non-empty string
@test "is_empty returns 1 for a non-empty string" {
  run is_empty "Hello"
  assert_failure
}

# Test: is_empty should return 0 when no argument is provided (because it's treated as an empty string)
@test "is_empty returns 0 when no argument is provided" {
  run is_empty
  assert_success
}
