#!/usr/bin/env bash

#######################################
# Checks if the provided argument is set (non-empty).
# Globals:
#   None
# Arguments:
#   string (string): The string to check.
# Outputs:
#   Writes nothing to stdout.
# Returns:
#   0 (true) if the string is set (non-empty), 1 (false) otherwise.
#######################################
is_set() {
  local str="${1:-}"

  if [[ -n "$str" ]]; then
    return 0
  else
    return 1
  fi
}

#######################################
# Checks if the provided argument is empty.
# Globals:
#   None
# Arguments:
#   string (string): The string to check.
# Outputs:
#   Writes nothing to stdout.
# Returns:
#   0 (true) if the string is empty, 1 (false) otherwise.
#######################################
is_empty() {
  local str="${1:-}"

  if [[ -z "$str" ]]; then
    return 0
  else
    return 1
  fi
}
