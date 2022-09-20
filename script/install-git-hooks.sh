#!/bin/sh

set -e

#
# Install all files in the hooks/ directory as Git hooks.
#

GIT_DIR=$(git rev-parse --show-toplevel)
HOOK_DIR="$GIT_DIR"/.git/hooks

for FILE in hooks/* ; do
    ln -s "$GIT_DIR/$FILE" "$HOOK_DIR/${FILE##*/}"
done
