#!/bin/sh

set -e

# Enable the running of this script from any subdirectory without moving to root.
cd "$(dirname "$0")/.."

code --list-extensions > vscode/extensions.txt
