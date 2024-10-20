#!/usr/bin/env bats

setup() {
  bats_load_library bats-support
  bats_load_library bats-assert
  bats_load_library bats-file
  load "../src/http.sh"
  temp_dir="$(temp_make)"
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

# Test: download should download a file
@test "download should download a file" {
  local file="${temp_dir}/image.png"
  run download "https://httpbin.org/image/png" "$file"
  assert_success
  # Check if the file exists
  assert_file_exist "$file"
}

# Test: download should download multiple files
@test "download should download multiple files" {
  run download "https://httpbin.org/image/{jpeg,png,svg}" "${temp_dir}/image.#1"
  assert_success
  # Check if files exists
  assert_file_exist "${temp_dir}/image.jpeg"
  assert_file_exist "${temp_dir}/image.png"
  assert_file_exist "${temp_dir}/image.svg"
}

# Test: download should output filenames
@test "download should output filenames" {
  run download "https://httpbin.org/image/{png,jpeg}" "${temp_dir}/image.#1"
  assert_success
  # Check if png and jpeg files are present in the output, regardless of order
  assert_line "${temp_dir}/image.png"
  assert_line "${temp_dir}/image.jpeg"
}

teardown() {
  temp_del "$temp_dir"
}
