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
  local json

  if [ -t 0 ]; then
    json=${1:?Error: Missing <json> argument}
  else
    json=$(cat)
  fi

  if [ -z "$json" ]; then
    echo "Error: Empty JSON string"
    return 1
  fi

  echo "$json" | jq -rc '.[]'
}
