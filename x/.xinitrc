#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

xset +fp ~/.fonts
xset fp rehash
xset dpms off
#xset r rate 280 30

monitors=$(xrandr -q | grep -oE "^.* connected (primary )?[0-9]+")

if [[ $monitors == *"HDMI"* && $monitors == *"VGA"* ]]; then
    . ~/bin/monitors.sh Home &
elif [[ $monitors == *"LVDS"* && $monitors == *"VGA"* ]]; then
    . ~/bin/monitors.sh Work &
fi

#. ~/bin/wallpaper.sh &
#. ~/bin/bar.sh &

sxhkd -m 1 &

compton --config ~/.compton.conf &

dunst &

# make the cursor point in the 'right' direction
xsetroot -cursor_name left_ptr &

rofi -key-run SuperL+d -modi "run" &

setxkbmap -model pc101 -layout us,bg -variant ,phonetic -option grp:alt_shift_toggle caps:escape &

urxvtd -q -f -o &

unclutter &

#xautolock -locker ~/bin/lock.sh -time 7 -corners -000 &

# set shell that sxhkd uses to execute commands:
export SXHKD_SHELL=sh

# TODO: test this
export INFINALITY_FT_BRIGHTNESS="-10"
export INFINALITY_FT_FILTER_PARAMS="0.00 0.35 0.35 0.35 0.00"

redshift-gtk &

wew | yawee.sh &

exec xwait

