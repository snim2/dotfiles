#!/bin/bash

set -o errexit
set -o nounset

BIN_DIR="${HOME}/bin"
TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)

if [[ ! -L "${BIN_DIR}" || ! -d  "${BIN_DIR}" ]]
then
    echo "${BIN_DIR} is NOT a symlink."
    rm -f "${BIN_DIR}"
    ln -s "${TOP_LEVEL_DIR}/bin" "${BIN_DIR}"
else
    echo "${BIN_DIR} is a symlink."
fi
