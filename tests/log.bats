#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  load "../src/log.sh"
}

# Test: log.debug should output a correctly formatted debug message
@test "log.debug should output debug message" {
  run log.debug "Test debug message"
  assert_output --partial "DEBUG"
  assert_output --partial "Test debug message"
}

# Test: log.notice should output a correctly formatted notice message
@test "log.notice should output notice message" {
  run log.notice "Test notice message"
  assert_output --partial "NOTICE"
  assert_output --partial "Test notice message"
}

# Test: log.warning should output a correctly formatted warning message
@test "log.warning should output warning message" {
  run log.warning "Test warning message"
  assert_output --partial "WARNING"
  assert_output --partial "Test warning message"
}

# Test: log.error should output a correctly formatted error message
@test "log.error should output error message" {
  run log.error "Test error message"
  assert_output --partial "ERROR"
  assert_output --partial "Test error message"
}

# Test: log.success should output a correctly formatted success message
@test "log.success should output success message" {
  run log.success "Test success message"
  assert_output --partial "SUCCESS"
  assert_output --partial "Test success message"
}

# Test: log.success should output a valid timestamp format
@test "log.success should output valid timestamp format" {
  run log.success "Test success message"
  # Verify that the output contains a valid timestamp format (YYYY-MM-DD)
  assert_output --regexp "[0-9]{4}-[0-9]{2}-[0-9]{2}"
}

# Test: NO_COLOR should disable colored output
@test "NO_COLOR should disable colored output" {
  export NO_COLOR=1
  run log.success "Test success message without color"
  assert_output --partial "SUCCESS"
  assert_output --partial "Test success message without color"
  # Ensure there are no color escape sequences (i.e., no \033 or ANSI escape codes)
  refute_output --regexp $'\033'
  # Clean up environment variable
  unset NO_COLOR
}

# Test: log.debug should not output when LOG_DEBUG_DISABLED is set
@test "log.debug should not output when LOG_DEBUG_DISABLED is set" {
  export LOG_DEBUG_DISABLED=1
  run log.debug "Test debug message"
  # Verify that no output is produced when logging is disabled
  assert_output ""
  # Clean up environment variable
  unset LOG_DEBUG_DISABLED
}
