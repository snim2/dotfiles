#!/bin/bash

set -o errexit
set -o nounset

KEYBINDINGS_DIR="${HOME}/Library/KeyBindings/"
KEYBINDINGS="DefaultKeyBinding.dict"
TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)

mkdir -p "${KEYBINDINGS_DIR}"

if [[ ! -L "${KEYBINDINGS_DIR}/${KEYBINDINGS}" || ! -e  "${KEYBINDINGS_DIR}/${KEYBINDINGS}" ]]
then
    echo "${KEYBINDINGS_DIR}/${KEYBINDINGS} is NOT a symlink."
    rm -f "${KEYBINDINGS_DIR}/${KEYBINDINGS}"
    ln -s "${TOP_LEVEL_DIR}/${KEYBINDINGS}" "${KEYBINDINGS_DIR}/${KEYBINDINGS}"
else
    echo "${KEYBINDINGS_DIR}/${KEYBINDINGS} is a symlink."
fi
