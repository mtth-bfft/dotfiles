#!/bin/bash

# Strict mode
set -euo pipefail

# Sourcing this script will fail.
SCRIPT=`readlink -f -- $0`
REPO=`dirname "$SCRIPT"`
ZSH=`which zsh`
USER=`whoami`

for f in zshrc gitconfig; do
    if [[ -f "$HOME/.$f" && ! -h "$HOME/.$f" ]]; then
        cp -v "$HOME/.$f" "$HOME/.$f.bak"
    fi
        rm -v -f "$HOME/.$f" && ln -v -s "$REPO/$f" "$HOME/.$f"
done

# Create the location where the directory stack will be stored
mkdir -p .cache/zsh/

echo " [*] Changing default shell for $USER"
chsh -s "$ZSH" "$USER"

