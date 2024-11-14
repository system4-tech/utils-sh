#!/usr/bin/env bash

#######################################
# Makes HTTP request using curl.
# Arguments:
#   url - The URL for the request
#   method - HTTP method (GET, POST, etc.)
#   additional args - Additional arguments for curl
# Outputs:
#   Response from the server
#######################################
_http() {
  local url method

  url=${1:?missing required <url> argument}
  shift

  # Extract method from the calling function name (http.get -> GET)
  method=${FUNCNAME[1]}
  method=${method#http.} # remove "http." prefix
  method=${method^^}     # convert to uppercase 

  curl "$url" "$@" \
    --request "$method" \
    --fail-with-body \
    --silent \
    --location \
    --retry-connrefused \
    --max-time "${HTTP_MAX_TIME:-180}" \
    --retry "${HTTP_RETRY_NUM:-20}" \
    --retry-max-time "${HTTP_RETRY_MAX_TIME:-600}"
}

http.get() {
  _http "$@"
}

http.post() {
  local url data
  
  url=${1:?missing required <url> argument}
  data=${2:?missing required <data> argument}
  shift 2

  _http "$url" "$@" --data "$data" 
}

http.put() {
  local url data
  
  url=${1:?missing required <url> argument}
  data=${2:?missing required <data> argument}
  shift 2

  _http "$url" "$@" --data "$data" 
}

#######################################
# Downloads files request using curl.
# Arguments:
#   url - The URL for the request
#   additional args - Additional arguments for curl
# Outputs:
#   filename
#######################################
download() {
  local url path

  url=${1:?missing required <url> argument}
  path=${2:?missing required <path> argument}
  shift 2

  curl "$url" "$@" \
    --output "$path" \
    --fail \
    --silent \
    --show-error \
    --location \
    --retry "${HTTP_RETRY_NUM:-20}" \
    --retry-connrefused \
    --compressed \
    --parallel \
    --parallel-max "${HTTP_PARALLEL_MAX:-10}" \
    --write-out "%{filename_effective}\n"
}
