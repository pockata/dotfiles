#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

if command -v gnome-keyring-daemon >> /dev/null; then
    eval $(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
    export SSH_AUTH_SOCK
fi

# Set output provider when using eGPU
NUM_PROVIDERS=$(xrandr --listproviders | head -1 | cut -d ":" -f3)
[ "$NUM_PROVIDERS" -gt 1 ] && xrandr --setprovideroutputsource 1 0

[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

xset +fp ~/.fonts
xset fp rehash

groups.sh > /dev/null

monitors=$(xrandr -q | grep -oE "^.* connected (primary )?[0-9]+")

if [[ "$monitors" == *"HDMI"* ]] && [[ "$monitors" == *"VGA"* ]]; then
    ~/bin/monitors.sh Home
elif [[ "$monitors" == *"LVDS"* ]] && [[ "$monitors" == *"VGA"* ]]; then
    ~/bin/monitors.sh Work
else
    nitrogen --restore &
    ~/bin/bar.sh &
fi

~/bin/setkeyboard.sh

sxhkd -m 1 &

compton --config ~/.compton.conf &

dunst &

notifyd &

notifier batterywarn &

# make the cursor point in the 'right' direction
xsetroot -cursor_name left_ptr &

urxvtd -q -f -o

unclutter &

xautolock -detectsleep -notify 7 -notifier "pop \"locking screen...\"" -locker ~/bin/lock.sh -time 9 -killtime 10 -killer "systemctl suspend" -corners -000 &

# set shell that sxhkd uses to execute commands:
export SXHKD_SHELL=sh

# TODO: test this
export INFINALITY_FT_BRIGHTNESS="-10"
export INFINALITY_FT_FILTER_PARAMS="0.00 0.35 0.35 0.35 0.00"

redshift-gtk &

if [ -f ~/bin/wew ]; then
    ~/bin/wew | yawee.sh &
else
    wew | yawee.sh &
fi

urxvtc -e zsh -c 'tmux has-session && tmux attach -d || tmux new -s main' &

exec xwait

