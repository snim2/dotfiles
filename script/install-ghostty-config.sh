#!/bin/bash

set -e

# Enable the running of this script from any subdirectory without moving to root.
cd "$(dirname "$0")/.."

# Where does Ghostty keep its config files?
# See: https://ghostty.org/docs/config
UNAME_OS=$(uname -s)
case "${UNAME_OS}" in
    Linux*)     SETTINGS_DIR="$HOME/.config/ghostty";;
    Darwin*)    SETTINGS_DIR="$HOME/Library/Application Support/com.mitchellh.ghostty";;
    *)          echo "Unknown OS: ${UNAME_OS}. Cannot install settings." && exit 1
esac
echo "Ghostty settings are stored in: ${SETTINGS_DIR}"

# Script to set up symlinks to config files.
TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)

for CONFIG_FILE in "$TOP_LEVEL_DIR"/ghostty/*
do
    if [[ ! -L "${SETTINGS_DIR}/${CONFIG_FILE##*/}" || ! -e "${SETTINGS_DIR}/${CONFIG_FILE##*/}" ]]
    then
        echo "${SETTINGS_DIR}/${CONFIG_FILE##*/} is NOT a symlink"
        rm -f "${SETTINGS_DIR}/${CONFIG_FILE##*/}"
        echo ln -s "${TOP_LEVEL_DIR}/ghostty/${CONFIG_FILE##*/}" "${SETTINGS_DIR}/${CONFIG_FILE##*/}"
        ln -s "${TOP_LEVEL_DIR}/ghostty/${CONFIG_FILE##*/}" "${SETTINGS_DIR}/${CONFIG_FILE##*/}"
    else
        echo "${SETTINGS_DIR}/${CONFIG_FILE##*/} is a symlink"
    fi
done
