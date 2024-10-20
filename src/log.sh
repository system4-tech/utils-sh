#!/usr/bin/env bash

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
