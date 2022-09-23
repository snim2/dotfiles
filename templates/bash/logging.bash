#!/usr/bin/env bash

exec 3>&2  # log to STDERR by default.

verbosity=3
level_silent=0
level_critical=1
level_error=2
level_warn=3
level_info=4
level_debug=5

__log_notify() { log $level_silent "NOTE] $1"; }
__log_critical() { log $level_critical "CRITICAL] $1"; }
__log_error() { log $level_error "ERROR] $1"; }
__log_warn() { log $level_warn "WARNING] $1"; }
__log_info() { log $level_info "INFO] $1"; }
__log_debug() { log $level_debug "DEBUG] $1"; }


log() {
    if [ ${verbosity} -ge "${1}" ]; then
        # Wrap output at 79 characters; indent all lines except the first.
        echo -e "[$(date +'%Y-%m-%d %H:%M:%S') $2" | fold -w79 -s | sed '2,$s/^/    /' >&3
    fi
}
