#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../utils.sh"
}

# Test: http.get should make a GET request
@test "http.get should make a GET request" {
  run http.get "https://httpbin.org/get"
  assert_success
  assert_output --partial '"url": "https://httpbin.org/get"'
}

# Test: http.post should make a POST request
@test "http.post should make a POST request" {
  run http.post "https://httpbin.org/post" "data=example"
  assert_success
  assert_output --partial '"data": "example"'
}

# Test: http.put should make a PUT request
@test "http.put should make a PUT request" {
  run http.put "https://httpbin.org/put" "data=example"
  assert_success
  assert_output --partial '"data": "example"'
}
