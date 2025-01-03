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

# Test: json_to_tsv outputs TSV for an array of objects
@test "json_to_tsv outputs TSV for an array of objects" {
  json_input='[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]'
  run json_to_tsv "$json_input"
  assert_success
  assert_output $'Alice\t30\nBob\t25'
}

# Test: json_to_tsv outputs TSV for an array of arrays
@test "json_to_tsv outputs TSV for an array of arrays" {
  json_input='[[1, 2, 3], [4, 5, 6]]'
  run json_to_tsv "$json_input"
  assert_success
  assert_line $'1\t2\t3'
  assert_line $'4\t5\t6'
}

# Test: json_to_tsv outputs TSV for mixed input types
@test "json_to_tsv outputs TSV for mixed input types" {
  json_input='[
    {"name": "Alice", "age": 30},
    [1, 2, 3],
    "single value"
  ]'
  run json_to_tsv "$json_input"
  assert_success
  assert_line $'Alice\t30'
  assert_line $'1\t2\t3'
  assert_line "single value"
}

# Test: json_to_tsv handles input provided via a pipe
@test "json_to_tsv works when input is piped" {
  json_input='[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]'
  run bats_pipe echo "$json_input" \| json_to_tsv
  assert_success
  assert_line $'Alice\t30'
  assert_line $'Bob\t25'
}

# Test: is_json detects valid JSON
@test "is_json detects valid JSON" {
  run is_json '{"name": "John", "age": 30}'
  assert_success
}

# Test: is_json fails for invalid JSON
@test "is_json fails for invalid JSON" {
  run is_json '{"name": "John", "age": 30,}'  # Trailing comma is invalid
  assert_failure
}

# Test: is_json fails for non-JSON input
@test "is_json fails for non-JSON input" {
  run is_json "Hello, world!"
  assert_failure
}

# Test: is_array detects JSON arrays
@test "is_array detects JSON arrays" {
  run is_array '[1, 2, 3]'
  assert_success
}

# Test: is_array fails for non-array JSON input
@test "is_array fails for non-array JSON input" {
  run is_array '{"key": "value"}'
  assert_failure
}

# Test: is_array fails for invalid JSON
@test "is_array fails for invalid JSON" {
  run is_array '[1, 2, 3,]'  # Trailing comma is invalid
  assert_failure
}

# Test: is_array fails for non-JSON input
@test "is_array fails for non-JSON input" {
  run is_array "Hello, world!"
  assert_failure
}

# Test: json_to_csv outputs CSV for an array of objects
@test "json_to_csv outputs CSV for an array of objects" {
  json_input='[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]'
  run json_to_csv "$json_input"
  assert_success
  assert_output $'"Alice",30\n"Bob",25'
}

# Test: json_to_csv outputs CSV for an array of arrays
@test "json_to_csv outputs CSV for an array of arrays" {
  json_input='[[1, 2, 3], [4, 5, 6]]'
  run json_to_csv "$json_input"
  assert_success
  assert_line '1,2,3'
  assert_line '4,5,6'
}

# Test: json_to_csv outputs CSV for mixed input types
@test "json_to_csv outputs CSV for mixed input types" {
  json_input='[
    {"name": "Alice", "age": 30},
    [1, 2, 3],
    "single value"
  ]'
  run json_to_csv "$json_input"
  assert_success
  assert_line '"Alice",30'
  assert_line "1,2,3"
  assert_line '"single value"'
}

# Test: json_to_csv handles input provided via a pipe
@test "json_to_csv works when input is piped" {
  json_input='[{"name": "Alice", "age": 30}, {"name": "Bob", "age": 25}]'
  run bats_pipe echo "$json_input" \| json_to_csv
  assert_success
  assert_line '"Alice",30'
  assert_line '"Bob",25'
}

# Test: json_length returns the correct length for a valid JSON array
@test "json_length returns correct length for a valid JSON array" {
  run json_length '[1, 2, 3, 4]'
  assert_success
  assert_output "4"
}

# Test: json_length returns 0 for an empty JSON array
@test "json_length returns 0 for an empty JSON array" {
  run json_length '[]'
  assert_success
  assert_output "0"
}

# Test: json_length fails for invalid JSON
@test "json_length fails for invalid JSON" {
  run json_length '[1, 2, 3,]'
  assert_failure
}

# Test: json_length handles input provided via a pipe
@test "json_length works when input is piped" {
  run bats_pipe echo '[1, 2, 3, 4]' \| json_length
  assert_success
  assert_output "4"
}
