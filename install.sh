#!/bin/bash

# Strict mode
set -euo pipefail

# Sourcing this script will fail.
SCRIPT=`realpath "$0"`
REPO=`dirname "$SCRIPT"`

for f in zshrc gitconfig; do
    if [[ -f "$HOME/.$f" && ! -h "$HOME/.$f" ]]; then
        cp -v "$HOME/.$f" "$HOME/.$f.bak"
    fi
        rm -v -f "$HOME/.$f" && ln -v -s "$REPO/$f" "$HOME/.$f"
done

