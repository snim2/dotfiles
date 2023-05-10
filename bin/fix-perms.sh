#!/bin/sh

# Fix permissions in this directory and further down the tree.
# Permissions should be suitable for storage on a prod instance.
find . -type d -exec chmod 0755 {} \;
find . -type f -exec chmod 0644 {} \;
