#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/url.sh"
}

# Test: urldecode should decode a URL-encoded string correctly
@test "urldecode decodes a URL-encoded string correctly" {
  run urldecode "Hello%20World%21"
  assert_success
  assert_output "Hello World!"
}

# Test: urldecode should decode a string with pluses and percent-encoded characters
@test "urldecode decodes a string with pluses and percent-encoded characters" {
  run urldecode "This+is%20a%20test%2E"
  assert_success
  assert_output "This is a test."
}

# Test: urlencode should encode a string for use in a URL
@test "urlencode encodes a string for use in a URL" {
  run urlencode "Hello World!"
  assert_success
  assert_output "Hello%20World%21"
}

# Test: urlencode should encode a string with special characters
@test "urlencode encodes a string with special characters" {
  run urlencode "This is a test: $&+,:;=?@#"
  assert_success
  assert_output "This%20is%20a%20test%3A%20%24%26%2B%2C%3A%3B%3D%3F%40%23"
}

# Test: urlparam should add a query parameter to a URL
@test "urlparam adds a query parameter to a URL" {
  run urlparam "https://example.com" "name" "John Doe"
  assert_success
  assert_output "https://example.com?name=John%20Doe"
}

# Test: urlparam should update an existing query parameter in the URL
@test "urlparam updates an existing query parameter in the URL" {
  run urlparam "https://example.com?name=Alice" "name" "Bob"
  assert_success
  assert_output "https://example.com?name=Bob"
}

# Test: urlparam should handle a URL with multiple query parameters
@test "urlparam adds a query parameter to a URL with multiple parameters" {
  run urlparam "https://example.com?name=Alice&age=30" "city" "New York"
  assert_success
  assert_output "https://example.com?name=Alice&age=30&city=New%20York"
}

# Test: urlparam should handle a URL with no query parameters
@test "urlparam adds the first query parameter to a URL with no query parameters" {
  run urlparam "https://example.com" "page" "2"
  assert_success
  assert_output "https://example.com?page=2"
}

# Test: urlparam should handle URL-encoded values
@test "urlparam handles URL-encoded values correctly" {
  run urlparam "https://example.com" "message" "Hello World!"
  assert_success
  assert_output "https://example.com?message=Hello%20World%21"
}

# Test: urlparam should allow an empty value
@test "urlparam allows an empty value" {
  run urlparam "https://example.com" "empty" ""
  assert_success
  assert_output "https://example.com?empty="
}

# Test: urlparam should fail if the URL is missing
@test "urlparam fails if the URL is missing" {
  run urlparam "" "key" "value"
  assert_failure
}

# Test: urlparam should fail if the key is missing
@test "urlparam fails if the key is missing" {
  run urlparam "https://example.com" "" "value"
  assert_failure
}
