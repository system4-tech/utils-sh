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

# Test: date_to_ms should return a valid timestamp in milliseconds for a valid date
@test "date_to_ms returns milliseconds for a valid date" {  
  run date_to_ms "2024-10-20"
  assert_success
  assert_output $(date -d "2024-10-20" +%s%3N) # get expected output in ms
}

# Test: date_to_ms should fail for an invalid date
@test "date_to_ms fails for an invalid date" {
  run date_to_ms "2024-13-40"
  assert_failure
}

# Test: date_to_ms should fail when date argument is empty
@test "date_to_ms fails for an empty date argument" {
  run date_to_ms ""
  assert_failure
}

# Test: date_to_ms should fail when no argument is passed
@test "date_to_ms fails when argument is missing" {
  run date_to_ms
  assert_failure
}

# Test: today should return today's date
@test "today returns today's date" {
  expected_date=$(date +%F)
  run today
  assert_success
  assert_output "$expected_date"
}

# Test: yesterday should return yesterday's date
@test "yesterday returns yesterday's date" {
  expected_date=$(date -d "yesterday" +%F)
  run yesterday
  assert_success
  assert_output "$expected_date"
}

# Test: tomorrow should return tomorrow's date
@test "tomorrow returns tomorrow's date" {
  expected_date=$(date -d "tomorrow" +%F)
  run tomorrow
  assert_success
  assert_output "$expected_date"
}
