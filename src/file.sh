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

#######################################
# Splits a file into smaller files with a specified number of lines.
# Globals:
#   None
# Arguments:
#   file (string): Path to the file to be split
#   prefix (string): Prefix for the output files
#   batch_size (int): Number of lines per split file
# Outputs:
#   Lists the generated split files
# Returns:
#   None
#######################################
file_split() {
  local file=${1:?Missing required <file> argument}
  local prefix=${2:?Missing required <prefix> argument}
  local batch_size=${3:?Missing required <batch_size> argument}

  split -l "$batch_size" --numeric-suffixes=1 "$file" "$prefix"

  ls "${prefix}"*
}
