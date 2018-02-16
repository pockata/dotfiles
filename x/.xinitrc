#!/bin/sh

if [ -d /etc/X11/xinit/xinitrc.d ] ; then
    for f in /etc/X11/xinit/xinitrc.d/?*.sh ; do
        [ -x "$f" ] && . "$f"
    done
    unset f
fi

# start gpg daemon
if command -v gnome-keyring-daemon >> /dev/null; then
    eval "$(gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)"
    export SSH_AUTH_SOCK
fi

# set output provider when using eGPU
NUM_PROVIDERS=$(xrandr --listproviders | head -1 | cut -d ":" -f3)
[ "$NUM_PROVIDERS" -gt 1 ] && xrandr --setprovideroutputsource 1 0

# load Xresources
[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

# load fonts
if [[ -d ~/.fonts ]]; then
    xset +fp ~/.fonts
    xset fp rehash
fi

# load wmutils configs
[[ -f ~/.wmrc ]] && . ~/.wmrc

# initialize groups script
groups.sh > /dev/null

# load predefined monitor layout 
#
# TODO: rewrite using mmutils
monitors=$(xrandr -q | grep -oE "^.* connected (primary )?[0-9]+")

if [[ "$monitors" == *"HDMI"* ]] && [[ "$monitors" == *"VGA"* ]]; then
    mattr "LVDS1" && xrandr --output LVDS1 --off
    ~/bin/monitors.sh "Home [eGPU]"
elif [[ "$monitors" == *"LVDS"* ]] && [[ "$monitors" == *"VGA"* ]]; then
    ~/bin/monitors.sh Work
else
    nitrogen --restore &
    ~/bin/bar.sh &
fi

# set keyboard defaults
#
# TODO: Run as udev rule on keyboard connect/disconnect
~/bin/setkeyboard.sh

compton --config /dev/null &

dunst &

# TODO: Use only notify-send
notifyd &

notifier batterywarn &

# make the cursor point in the 'right' direction
xsetroot -cursor_name left_ptr &

urxvtd -q -f -o

unclutter &

udiskie -q &

# xautolock -detectsleep -notifier "notify-send" -notify 30 -locker ~/bin/lock.sh -time 9 -killtime 10 -killer "systemctl suspend" -corners -000 &

# set shell that sxhkd uses to execute commands:
export SXHKD_SHELL=sh

redshift-gtk &

urxvtc -e zsh -c 'tmux has-session && tmux attach -d || tmux new -s main' &

greenclip daemon &

session=${1:-wmutils}
export WM_NAME="$session"

case $session in
    bspwm)
        sxhkd -c ~/.config/sxhkd/sxhkdrc_general ~/.config/sxhkd/sxhkdrc_bspwm &

        exec bspwm
        ;;

    wmutils)
        wew | yawee.sh &
        sxhkd -c ~/.config/sxhkd/sxhkdrc_general  ~/.config/sxhkd/sxhkdrc_wmutils &

        exec xwait
        ;;

    # No known session, try to run it as command
    *)
        exec $1
        ;;
esac

