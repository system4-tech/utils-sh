#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/date.sh"
}

# Test: is_date should return 0 for a valid date
@test "is_date returns 0 for a valid date" {
  run is_date "2024-10-20"
  assert_success
}

# Test: is_date should return 1 for an invalid date
@test "is_date returns 1 for an invalid date" {
  run is_date "2024-13-40"
  assert_failure
}

# Test: is_date should return 1 for an empty date string
@test "is_date returns 1 for an empty date string" {
  run is_date ""
  assert_failure
}

# Test: is_date should return 1 when argument is missing
@test "is_date returns 1 when argument is missing" {
  run is_date
  assert_failure
}
