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

# Test: fail should print an error message and exit with status 1
@test "fail prints error message and exits with status 1" {
  run fail "Something went wrong"
  assert_failure
  assert_output "Something went wrong"
}

# Test: fail should print an empty error message and exit with status 1 if no argument is passed
@test "fail exits with status 1 when no argument is provided" {
  run fail
  assert_failure
  assert_output ""
}

# Test: has_failed should return 1 if the last command failed
@test "has_failed returns 1 if the last command failed" {
  run false && has_failed
  assert_failure
}

# Test: has_failed should return 0 if the last command succeeded
@test "has_failed returns 0 if the last command succeeded" {
  run true && has_failed
  assert_success
}
