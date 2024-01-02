#!/bin/sh

# start gpg daemon
if command -v gnome-keyring-daemon >> /dev/null; then
    eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
    export SSH_AUTH_SOCK
fi

# load Xresources
[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

# load fonts
if [[ -d ~/.fonts ]]; then
    xset +fp ~/.fonts
    xset fp rehash
fi

# set keyboard defaults
#
# TODO: Run as udev rule on keyboard connect/disconnect
~/bin/setkeyboard.sh

dunst &
unclutter &

udiskie -q &

redshift-gtk &

alacritty -e zsh -c 'tmux has-session && tmux attach -d || tmux new -s main' &

greenclip daemon &

# a successor to compton
picom --config ~/.picom.conf &

plasmawindowed org.kde.plasma.volume --statusnotifier &
