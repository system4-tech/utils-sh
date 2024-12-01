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

#######################################
# Converts a date string to milliseconds since the Unix epoch.
# Assumes the provided date is valid; use is_date() to verify.
# Globals:
#   None
# Arguments:
#   date (string): Date string
# Outputs:
#   Writes milliseconds since Unix epoch to stdout
# Returns:
#   0 on success
#######################################
date_to_ms() {
  local date=${1:?missing required <date> argument}

  date -d "$date" +%s%3N
}

#######################################
# Gets today's date in YYYY-MM-DD format.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes today's date to stdout
# Returns:
#   0 on success
#######################################
today() {
  date +%F
}

#######################################
# Gets yesterday's date in YYYY-MM-DD format.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes yesterday's date to stdout
# Returns:
#   0 on success
#######################################
yesterday() {
  date -d "yesterday" +%F
}

#######################################
# Gets tomorrow's date in YYYY-MM-DD format.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes tomorrow's date to stdout
# Returns:
#   0 on success
#######################################
tomorrow() {
  date -d "tomorrow" +%F
}

#######################################
# Gets the current date and time in YYYY-MM-DD HH:MM:SS.sss format.
# Globals:
#   None
# Arguments:
#   None
# Outputs:
#   Writes the current date and time to stdout, including milliseconds if supported.
# Returns:
#   0 on success
#######################################
now() {
  date '+%Y-%m-%d %H:%M:%S.%3N'
}
