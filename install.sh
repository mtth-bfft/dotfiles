#!/bin/bash

# Strict mode
set -euo pipefail

# Check prerequisites
if ! which zsh >/dev/null 2>&1; then
	echo " [!] Please install zsh first" >&2
	exit 1
fi

# Sourcing this script will fail.
SCRIPT=`readlink -f -- $0`
REPO=`dirname "$SCRIPT"`
USER=`whoami`

# Locate zsh: on CentOS `which` gives /usr/bin/zsh but
# only /bin/zsh is registered in /etc/shells ...
ZSH=`grep zsh /etc/shells | head -n1`
if [[ -z $ZSH ]] || ! [[ -x $ZSH ]]; then
    ZSH=`which zsh`
fi

for f in zshrc vimrc gitconfig gdbinit; do
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

