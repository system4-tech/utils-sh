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

#######################################
# Prints an error message to stderr and exits the script.
# Globals:
#   None
# Arguments:
#   message (string): The error message to display.
# Outputs:
#   Writes the error message to stderr.
# Returns:
#   Exits the script with a status code of 1.
#######################################
fail() {
  local message="$*"
  echo "$message" >&2
  exit 1
}

#######################################
# Gets the directory of the current script.
# Globals:
#   BASH_SOURCE
# Arguments:
#   None
# Outputs:
#   Writes the directory path to stdout.
# Returns:
#   0 (true) if the directory is found, 1 (false) otherwise.
#######################################
script_dir() {
  realpath "$(dirname "${BASH_SOURCE[0]}")"
}

#######################################
# Looks up a file in predefined directories.
# Globals:
#   PATH
# Arguments:
#   filename (string): The name of the file to look up.
# Outputs:
#   Writes the file path to stdout if found.
# Returns:
#   0 (true) if the file is found, 1 (false) otherwise.
#######################################
file_lookup() {
  local filename="$1"
  local search_dirs=(
    "$(script_dir)"
    "$PWD"
  )

  # Add directories from PATH to search_dirs
  for dir in ${PATH//:/ }; do
    search_dirs+=("$dir")
  done

  for dir in "${search_dirs[@]}"; do
    local filepath="$dir/$filename"
    if [ -f "$filepath" ]; then
      echo "$filepath"
      return 0
    fi
  done

  return 1
}

#######################################
# Runs a script if found in predefined directories.
# Globals:
#   None
# Arguments:
#   filename (string): The name of the script to run.
#   ... (any): Additional arguments to pass to the script.
# Outputs:
#   Writes the script output to stdout.
# Returns:
#   0 (true) if the script runs successfully, 1 (false) otherwise.
#######################################
script_run() {
  local filename="$1"
  local output status
  if filepath=$(file_lookup "$filename"); then
    shift
    output="$("$filepath" "$@" 2>&1)"
    status=$?

    # make output and status available to other scripts
    export RUN_OUTPUT="$output"
    export RUN_STATUS="$status"

    echo "$output"
    return $status
  else
    return 1
  fi
}

#######################################
# Loads a script if found in predefined directories.
# Globals:
#   None
# Arguments:
#   filename (string): The name of the script to load.
# Outputs:
#   None
# Returns:
#   0 (true) if the script is loaded successfully, 1 (false) otherwise.
#######################################
script_load() {
  local filename="$1"
  if filepath=$(file_lookup "$filename"); then
    # shellcheck disable=SC1090
    source "$filepath"
  else
    return 1
  fi
}
