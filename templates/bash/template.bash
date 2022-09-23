#!/usr/bin/env bash

# Note: avoid temporary files with: diff <(wget -O - url1) <(wget -O - url2)

set -o errexit
set -o pipefail

# In some versions of Bash, `set -u` or `set -o nounset` will raise an error
# if `$@` is used and no arguments are passed to the script.
# See bash-4.1-alpha patches, 1.n:
#     https://tiswww.case.edu/php/chet/bash/CHANGES
if [[ -z "${*}" ]]; then
    ARGS=( "" )
else
    ARGS=( "${@}" )
fi
set -o nounset


# This file, and its directory, etc.
__dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
__file="$(basename "${BASH_SOURCE[0]}")"
__base="$(basename "${__file}" .bash)"
__root="$(cd "$(dirname "${__dir}")" && pwd)"
# shellcheck disable=SC2034
readonly __file __dir __base __root

# shellcheck source=templates/bash/logging.bash
source "${__dir}"/logging.bash

usage() {
    read -r -d '' __usage <<-EOF || true
    Usage: ${__file} [OPTIONS]

Options:
    -h      : Display this help message.
    -q      : Decrease logging verbosity. Can be repeated.
    -v      : Increase logging verbosity. Can be repeated.
    -l FILE : Redirect logging to FILE instead of STDERR.
EOF
    echo "${__usage}"
}

# Clean up any services or temporary files etc. here.
function cleanup_on_error() {
    :
}

main() {
    while getopts "hqvl:" opt; do
        case "$opt" in
        h) usage; exit 0 ;;
        q) (( verbosity = verbosity - 1 )) ;;
        v) (( verbosity = verbosity + 1 )) ;;
        l) exec 3>>"${OPTARG}" ;;
        *) error "Invalid options: $1"; usage; exit 1 ;;
        esac
    done
}

main "${ARGS[@]}"

trap cleanup_on_error EXIT

# __log_notify "message..."
# __log_critical "message..."
# __log_error "message..."
# __log_warn "message..."
# __log_info "message..."
# __log_debug "message..."
