#!/bin/bash

set -e

#
# Install all versions of Python needed by cloned repositories.
#
#
# Assumes that pyenv-virtualpython is already installed and
# initialised in this shell. The assumed directory structure is:
#
#    $HOME/code/gitplatform/org/repo/.python-version
#
# For example:
#
#     $HOME/code/github.com/snim2/dotfiles/.python-version
#

for PYTHONVERSION in $(cat "$HOME"/code/*/*/*/.python-version | sort | uniq)
do
    echo "Installing ${PYTHONVERSION} ..."
    pyenv install "${PYTHONVERSION}"
done
