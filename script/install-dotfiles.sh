#!/bin/bash

set -e

#
# Script to set up symlinks to these dotfiles in $HOME.
#

# Install nano syntax highlighting files.
if [[ ! -d "$HOME/.nano" ]]; then
    git clone git@github.com:serialhex/nano-highlight.git "$HOME/.nano"
fi

TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)
for DOTFILE in _*
do
    if [[ ! -L "$HOME/.${DOTFILE:1}" || ! -e "$HOME/.${DOTFILE:1}" ]]
    then
        echo "$HOME/.${DOTFILE:1} is NOT a symlink"
        rm -f "$HOME/.${DOTFILE:1}"
        ln -s "${TOP_LEVEL_DIR}/${DOTFILE}" "$HOME/.${DOTFILE:1}"
    else
        echo "$HOME/.${DOTFILE:1} is a symlink"
    fi
done
