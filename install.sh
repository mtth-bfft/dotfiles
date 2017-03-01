#!/bin/bash

set -euo pipefail
IFS=$'\n\t'
umask 0077

# Environment checks, prerequisites
if ! zsh -c "echo" &>/dev/null; then
    echo " [!] Please install zsh to use these dotfiles." >&2
    exit 1
fi

SCRIPT=`readlink -f -- $0`
REPO=`dirname "$SCRIPT"`
HOME=`dirname "$REPO"`
USER=`stat --format="%u" "$SCRIPT"`
if ! which zsh &>/dev/null; then
    ZSH=`grep zsh /etc/shells | head -n1`
else
    ZSH=`which zsh`
fi

function install_dotfile() {
    [[ -h "$HOME/$2" ]] && rm -f "$HOME/$2"
    [[ -f "$HOME/$2" ]] && mv -v "$HOME/$2" "$HOME/$2.bak"
    mkdir -p "$(dirname "$HOME/$2")"
    ln -s "$REPO/$1" "$HOME/$2"
}

install_dotfile xresources .config/xresources
install_dotfile xmodmap .config/xmodmap
install_dotfile i3config .config/i3/config
install_dotfile i3status .config/i3status/config
install_dotfile htoprc .config/htop/htoprc
install_dotfile vimcolors .vim/colors/custom-colors.vim

for f in xinitrc zprofile zshrc vimrc gitconfig gdbinit; do
    install_dotfile $f ".$f"
done

mkdir -p "$HOME/.cache/zsh/"

# Skip chsh when we can't touch the root partition
[[ "${1:-}" == "--no-chsh" ]] && exit 0

# Check that ZSH is the default shell
DEFSHELL=`getent passwd "$USER" | cut -d ":" -f 7-`
DEFSHELL=`basename "$DEFSHELL"`
if [[ "$DEFSHELL" != "zsh" ]]; then
    echo " [*] Changing default shell for $USER to $ZSH"
    chsh -s "$ZSH"
fi

