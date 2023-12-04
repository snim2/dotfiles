#!/bin/bash

set -e

# Enable the running of this script from any subdirectory without moving to root.
cd "$(dirname "$0")/.."

# Install extensions.
xargs -n 1 code --install-extension < vscode/extensions.txt

# Where does VSCode keep its config files?
# See: https://code.visualstudio.com/docs/getstarted/settings#_settingsjson
UNAME_OS=$(uname -s)
case "${UNAME_OS}" in
    Linux*)     SETTINGS_DIR="$HOME/.config/Code/User";;
    Darwin*)    SETTINGS_DIR="$HOME/Library/Application Support/Code/User";;
    *)          echo "Unknown OS: ${UNAME_OS}. Cannot install settings." && exit 1
esac
echo "VSCode settings are stored in: ${SETTINGS_DIR}"

# Script to set up symlinks to config files.
TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
for JSON_FILE in vscode/user/*.json
do
    if [[ ! -L "${SETTINGS_DIR}/${JSON_FILE##*/}" || ! -e "${SETTINGS_DIR}/${JSON_FILE##*/}" ]]
    then
        echo "${SETTINGS_DIR}/${JSON_FILE##*/} is NOT a symlink"
        rm -f "${SETTINGS_DIR}/${JSON_FILE##*/}"
        ln -s "${TOP_LEVEL_DIR}/${JSON_FILE}" "${SETTINGS_DIR}/${JSON_FILE##*/}"
    else
        echo "${SETTINGS_DIR}/${JSON_FILE##*/} is a symlink"
    fi
done
