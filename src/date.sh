#!/usr/bin/env bash

#######################################
# Checks if the provided argument is a valid date.
# Globals:
#   None
# Arguments:
#   date (string): Date string
# Outputs:
#   Writes nothing to stdout
# Returns:
#   0 (true) if the date is valid, 1 (false) otherwise.
#######################################
is_date() {
  local date=${1:?missing required <date> argument}
  
  if date -d "$date" &>/dev/null; then
    return 0
  else
    return 1
  fi
}
