#!/bin/bash

# Strict mode
set -euo pipefail

# Prerequisites
if ! which zsh >/dev/null 2>&1; then
    echo " [!] Please install zsh first" >&2
    exit 1
fi

SCRIPT=`readlink -f -- $0`
REPO=`dirname "$SCRIPT"`
USER=`id -u`
if ! which zsh &>/dev/null; then
    ZSH=`grep zsh /etc/shells | head -n1`
else
    ZSH=`which zsh`
fi

function install_dotfile() {
    if [[ -f "$HOME/$2" && ! -h "$HOME/$2" ]]; then
        cp -v "$HOME/$2" "$HOME/$2.bak"
    fi
    [[ -d "$(dirname "$HOME/$2")" ]] || mkdir -p "$(dirname "$HOME/$2")"
    rm -v -f "$HOME/$2"
    ln -v -s "$REPO/$1" "$HOME/$2"
}

install_dotfile xresources .config/xresources
install_dotfile xmodmap .config/xmodmap
install_dotfile i3config .config/i3/config
install_dotfile htoprc .config/htop/htoprc
install_dotfile vimcolors .vim/colors/custom-colors.vim

for f in xinitrc zprofile zshrc vimrc gitconfig gdbinit; do
    install_dotfile $f ".$f"
done

mkdir -p "$HOME/.cache/zsh/"

# Check that ZSH is the default shell
DEFSHELL=`getent passwd "$USER" | cut -d ":" -f 7-`
DEFSHELL=`basename "$DEFSHELL"`
echo " [*] Default shell is $DEFSHELL"
if [[ "$DEFSHELL" != "zsh" ]]; then
    echo " [*] Changing default shell for $USER to $ZSH"
    chsh -s "$ZSH"
    exec "$ZSH"
fi

