#!/bin/bash

set -e

TOP_LEVEL_DIR=$(git rev-parse --show-toplevel)

# Symlink the emacs.d directory.
if [[ ! -L "$HOME/.emacs.d" || ! -e "$HOME/.emacs.d" ]]; then
    echo "Symlinking ~/.emacs.d -> ${TOP_LEVEL_DIR}/emacs.d"
    rm -rf "$HOME/.emacs.d"
    ln -s "${TOP_LEVEL_DIR}/emacs.d" "$HOME/.emacs.d"
else
    echo "~/.emacs.d is already a symlink"
fi

# Copy private.el template if no private.el exists yet.
if [[ ! -f "$HOME/.emacs.d/private.el" ]]; then
    echo "Copying private.el.template -> ~/.emacs.d/private.el"
    cp "${TOP_LEVEL_DIR}/emacs.d/private.el.template" "$HOME/.emacs.d/private.el"
    echo "Edit ~/.emacs.d/private.el to add your personal settings."
fi

# Start the Emacs server via Homebrew services.
brew services start emacs
