#!/usr/bin/env bash

#######################################
# Decodes a URL-encoded string.
# Globals:
#   None
# Arguments:
#   url (string): URL-encoded string to decode
# Outputs:
#   Writes the decoded string to stdout
# Returns:
#   0 on success
#######################################
urldecode() {
  local url=${1:-}
  local decoded="${url//+/ }"  # Replace + with a space
  printf '%b' "${decoded//%/\\x}"  # Decode percent-encoded characters
}

#######################################
# Encodes a string to be used in a URL.
# Globals:
#   None
# Arguments:
#   url (string): String to encode
# Outputs:
#   Writes the URL-encoded string to stdout
# Returns:
#   0 on success
#######################################
urlencode() {
  local url=${1:-}
  local encoded=""
  local char 
  
  for ((i = 0; i < ${#url}; i++)); do
    char="${url:i:1}"
    # Alphanumeric and some special characters don't need encoding
    if [[ "$char" =~ [A-Za-z0-9._~-] ]]; then
      encoded+="$char"
    else
      # Percent-encode any other character
      printf -v encoded '%s%%%02X' "$encoded" "'$char"
    fi
  done
  echo "$encoded"
}

#######################################
# Adds or updates a query parameter in a URL.
# If the key already exists, it updates the value, otherwise it adds the parameter.
# Globals:
#   None
# Arguments:
#   url (string): Base URL to modify
#   key (string): The query parameter key to add/update
#   value (string): The value to associate with the query parameter key
# Outputs:
#   Writes the modified URL with the added/updated query parameter to stdout
# Returns:
#   0 on success
#######################################
urlparam() {
  local url=${1:?missing required <url> argument}
  local key=${2:?missing required <key> argument}
  local value=${3:-}

  # URL encode the key and value
  key=$(urlencode "$key")
  value=$(urlencode "$value")

  if [[ "$url" =~ ([?&])$key= ]]; then
    url=$(echo "$url" | sed -E "s/([?&]$key=)[^&]*/\1$value/")
  elif [[ "$url" == *"?"* ]]; then
    url="$url&$key=$value"
  else
    url="$url?$key=$value"
  fi

  echo "$url"
}
