#!/usr/bin/env bash

#######################################
# Converts a JSON array into newline-delimited JSON (NDJSON).
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
# Outputs:
#   Writes each item in the JSON array to stdout, one per line
# Returns:
#   0 on success
#######################################
json_to_ndjson() {
  local json=${1:-}

  if [ -z "$json" ] && [ -p /dev/stdin ]; then
    json=$(< /dev/stdin)    
  fi

  if [ -z "$json" ]; then
    echo "Error: Empty JSON string"
    return 1
  fi

  echo "$json" | jq -rc '.[]'
}

#######################################
# Converts a JSON array into TSV format with only values.
# Supports arrays, array of arrays, and array of objects.
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
# Outputs:
#   Writes TSV-formatted values to stdout
# Returns:
#   0 on success, 1 on error
#######################################
json_to_tsv() {
  local json=${1:-}

  if [ -z "$json" ] && [ -p /dev/stdin ]; then
    json=$(< /dev/stdin)
  fi

  if [ -z "$json" ]; then
    echo "Error: Empty JSON string" >&2
    return 1
  fi

  # todo: support streaming
  echo "$json" | jq -r '
    .[] |
    if type == "array" then
      .
    elif type == "object" then
      [.[]]
    else
      [.] # Wrap single values into an array
    end | @tsv
  '
}

#######################################
# Checks if a string is valid JSON.
# Globals:
#   None
# Arguments:
#   json (string): Input string to validate
# Outputs:
#   None
# Returns:
#   0 if the input is valid JSON, 1 otherwise
#######################################
is_json() {
  local json="${1:-}"

  if echo "${json}" | jq -e . >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

#######################################
# Checks if a string is a valid JSON array.
# Globals:
#   None
# Arguments:
#   json (string): Input string to validate as a JSON array
# Outputs:
#   None
# Returns:
#   0 if the input is a valid JSON array, 1 otherwise
#######################################
is_array() {
  local json="${1:-}"

  if echo "${json}" | jq -e 'if type == "array" then true else false end' >/dev/null 2>&1; then
    return 0
  else
    return 1
  fi
}

#######################################
# Converts a JSON array into CSV format with only values.
# Supports arrays, array of arrays, and array of objects.
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
# Outputs:
#   Writes CSV-formatted values to stdout
# Returns:
#   0 on success, 1 on error
#######################################
json_to_csv() {
  local json=${1:-}

  if [ -z "$json" ] && [ -p /dev/stdin ]; then
    json=$(< /dev/stdin)
  fi

  if [ -z "$json" ]; then
    echo "Error: Empty JSON string" >&2
    return 1
  fi

  # todo: support streaming
  echo "$json" | jq -r '
    .[] |
    if type == "array" then
      .
    elif type == "object" then
      [.[]]
    else
      [.] # Wrap single values into an array
    end | @csv
  '
}

#######################################
# Counts the length of a JSON array.
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
#   path (string): Optional. JSON path to the array (default: ".")
# Outputs:
#   Writes the length of the JSON array to stdout
# Returns:
#   0 on success, 1 on error
#######################################
json_length() {
  local json=${1:-}
  local path=${2:-.}

  if [ -z "$json" ] && [ -p /dev/stdin ]; then
    json=$(< /dev/stdin)
  fi

  if [ -z "$json" ]; then
    echo "Error: Empty JSON string" >&2
    return 1
  fi

  echo "${json}" | jq -r "${path} | length" 
}
