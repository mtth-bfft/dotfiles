#!/bin/bash

# Strict mode
set -euo pipefail

# Sourcing this script will fail.
SCRIPT=`readlink -f -- $0`
REPO=`dirname "$SCRIPT"`
ZSH=`which zsh`
USER=`whoami`

for f in zshrc vimrc gitconfig; do
    if [[ -f "$HOME/.$f" && ! -h "$HOME/.$f" ]]; then
        cp -v "$HOME/.$f" "$HOME/.$f.bak"
    fi
        rm -v -f "$HOME/.$f" && ln -v -s "$REPO/$f" "$HOME/.$f"
done

# Create the location where the directory stack will be stored
mkdir -p "$HOME/.cache/zsh/"

# Check that ZSH is the default shell
DEFSHELL=`grep "^$USER:" /etc/passwd | cut -d ":" -f 7-`
DEFSHELL=`basename "$DEFSHELL"`
echo " [*] Default shell is $DEFSHELL"
if [[ "$DEFSHELL" != "zsh" ]]; then
	echo " [*] Changing default shell for $USER to $ZSH"
	chsh -s "$ZSH" "$USER"
	exec "$ZSH"
fi

