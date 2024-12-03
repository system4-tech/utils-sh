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

  if [ -z "$json" ]; then
    if [ -p /dev/stdin ]; then
      json=$(< /dev/stdin)
    else
      echo "Error: Empty JSON string" >&2
      return 1
    fi
  fi

  jq -rc '.[]' <<< "$json"
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

  if [ -z "$json" ]; then
    if [ -p /dev/stdin ]; then
      json=$(< /dev/stdin)
    else
      echo "Error: Empty JSON string" >&2
      return 1
    fi
  fi

  jq -r '
    .[] |
    if type == "array" then .
    elif type == "object" then [.[]]
    else [.] end | @tsv
  ' <<< "$json"
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
  jq -e . >/dev/null 2>&1 <<< "${1:-}"
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
  jq -e 'type == "array"' >/dev/null 2>&1 <<< "${1:-}"
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

  if [ -z "$json" ]; then
    if [ -p /dev/stdin ]; then
      json=$(< /dev/stdin)
    else
      echo "Error: Empty JSON string" >&2
      return 1
    fi
  fi

  jq -r '
    .[] |
    if type == "array" then .
    elif type == "object" then [.[]]
    else [.] end | @csv
  ' <<< "$json"
}

#######################################
# Counts the length of a JSON array.
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
# Outputs:
#   Writes the length of the JSON array to stdout
# Returns:
#   0 on success, 1 on error
#######################################
json_length() {
  local json=${1:-}

  if [ -z "$json" ]; then
    if [ -p /dev/stdin ]; then
      json=$(< /dev/stdin)
    else
      echo "Error: Empty JSON string" >&2
      return 1
    fi
  fi

  jq -r 'length' <<< "$json"
}

#######################################
# Checks if a JSON array is empty.
# Globals:
#   None
# Arguments:
#   json (string): JSON array as a string
# Outputs:
#   None
# Returns:
#   0 if the JSON array is empty, 1 otherwise
#######################################
is_json_empty() {
  jq -e 'length == 0' >/dev/null 2>&1 <<< "${1:-}"
}