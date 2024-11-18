#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/json.sh"
}

# Test: json_to_ndjson should return 0 and output NDJSON for a valid JSON array
@test "json_to_ndjson outputs NDJSON for a valid JSON array" {
  json_input='[{"name": "John"}, {"name": "Jane"}]'
  run json_to_ndjson "$json_input"
  assert_success
  assert_line '{"name":"John"}'
  assert_line '{"name":"Jane"}'
}

# Test: json_to_ndjson should fail for an empty JSON string
@test "json_to_ndjson fails for an empty JSON string" {
  run json_to_ndjson ""
  assert_failure
}

# Test: json_to_ndjson should fail when no argument is provided and no input is piped
@test "json_to_ndjson fails when argument is missing and no input is piped" {
  run json_to_ndjson
  assert_failure
}

# Test: json_to_ndjson should handle an invalid JSON string
@test "json_to_ndjson fails for an invalid JSON string" {
  invalid_json='[{"name": "John", "age": 30,}]'  # Trailing comma is invalid
  run json_to_ndjson "$invalid_json"
  assert_failure
}

# Test: json_to_ndjson should correctly handle input provided via a pipe
@test "json_to_ndjson works when input is piped" {
  json_input='[{"name": "John"}, {"name": "Jane"}]'  
  run bats_pipe echo "$json_input" \| json_to_ndjson
  assert_success
  assert_line '{"name":"John"}'
  assert_line '{"name":"Jane"}'
}
