#!/bin/bash

set -e

#
# Install all versions of Ruby needed by cloned repositories.
#
#
# Assumes that rbenv is already installed and initialised
# in this shell. The assumed directory structure is:
#
#    $HOME/code/gitplatform/org/repo/.ruby-version
#
# For example:
#
#     $HOME/code/github.com/snim2/dotfiles/.ruby-version
#

for RUBYVERSION in $(cat "$HOME"/code/*/*/*/.ruby-version | sort | uniq)
do
    if [[ -n ${RUBYVERSION} ]]
    then
        echo "Installing ${RUBYVERSION} ..."
        rbenv install -s "${RUBYVERSION}"
    fi
done
