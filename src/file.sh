#!/usr/bin/env bash

#######################################
# Checks if the provided argument is a regular file.
# Globals:
#   None
# Arguments:
#   file (string): Path to the file
# Outputs:
#   Writes nothing to stdout
# Returns:
#   0 (true) if the file exists and is a regular file, 1 (false) otherwise.
#######################################
file_exists() {
  local file=${1:?missing required <file> argument}
  
  if [[ -f "$file" ]]; then
    return 0
  else
    return 1
  fi
}

#######################################
# Checks if the provided argument is a directory.
# Globals:
#   None
# Arguments:
#   dir (string): Path to the directory
# Outputs:
#   Writes nothing to stdout
# Returns:
#   0 (true) if the directory exists, 1 (false) otherwise.
#######################################
dir_exists() {
  local dir=${1:?missing required <dir> argument}
  
  if [[ -d "$dir" ]]; then
    return 0
  else
    return 1
  fi
}
