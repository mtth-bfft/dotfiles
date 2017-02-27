#!/bin/sh

userresources=$HOME/.config/xresources
usermodmap=$HOME/.config/xmodmap
sysresources=/etc/X11/xinit/xresources
sysmodmap=/etc/X11/xinit/xmodmap

if [ -f $sysresources ]; then
    xrdb -merge $sysresources
fi

if [ -f $sysmodmap ]; then
    xmodmap $sysmodmap
fi

if [ -f "$userresources" ]; then
    xrdb -merge "$userresources"
fi

if [ -f "$usermodmap" ]; then
    xmodmap "$usermodmap"
fi

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
	for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
		[ -x "$f" ] && . "$f"
	done
	unset f
fi

pamixer --set-mute &
pamixer --set-volume 50 &
pamixer --default-source --set-mute &
pamixer --default-source --set-volume 0 &

exec i3
