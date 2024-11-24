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
