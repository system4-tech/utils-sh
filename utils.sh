#!/usr/bin/env bash
#
# Shell utility programs.

# Color constants
readonly COLOR_WHITE=37
readonly COLOR_BLUE=34
readonly COLOR_YELLOW=33
readonly COLOR_RED=31
readonly COLOR_GREEN=32

#######################################
# Logs a message with a specified color and level.
# Globals:
#   LOG_<LEVEL>_DISABLED
# Arguments:
#   color
#   message
# Outputs:
#   YYYY-MM-DD hh:mm:ss.SSS  <LEVEL> --- <message>
#######################################
_log() {
  local color instant level

  color=${1:?missing required <color> argument}
  shift

  # Determine log level from caller's function name
  level=${FUNCNAME[1]}
  level=${level#log.} # remove "log." prefix
  level=${level^^}    # convert to uppercase 

  # Check if logging for this level is disabled
  if [[ ! -v "LOG_${level}_DISABLED" ]]; then
    # Get timestamp with millisecond precision, fallback to basic if %-3N is unsupported
    instant=$(date '+%F %T.%-3N' 2>/dev/null || date '+%F %T' || :)

    # https://no-color.org/
    if [[ -v NO_COLOR ]]; then
      printf -- '%s  %s --- %s\n' "$instant" "$level" "$*" 1>&2 || :
    else
      printf -- '\033[0;%dm%s  %s --- %s\033[0m\n' "$color" "$instant" "$level" "$*" 1>&2 || :
    fi
  fi
}

log.debug() {
  _log "$COLOR_WHITE" "$@"
}

log.notice() {
  _log "$COLOR_BLUE" "$@"
}

log.warning() {
  _log "$COLOR_YELLOW" "$@" 
}

log.error() {
  _log "$COLOR_RED" "$@"
}

log.success() {
  _log "$COLOR_GREEN" "$@"
}

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
    --fail \
    --silent \
    --show-error \
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
