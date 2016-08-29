#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

xset +fp ~/.fonts
xset -b
xset fp rehash
xset dpms off

if ! xinput list --name-only | grep -qi "CM Storm Quickfire Rapid i"; then
    xset r rate 280 45
fi

if xinput list --name-only | grep -qi "TPPS/2 IBM TrackPoint"; then
    # http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint
    # enable trackpoint vertical scroll
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
    # horizontal scroll
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5
    # disable touchpad
    synclient TouchpadOff=1
fi

monitors=$(xrandr -q | grep -oE "^.* connected (primary )?[0-9]+")

if [[ $monitors == *"HDMI"* && $monitors == *"VGA"* ]]; then
    ~/bin/monitors.sh Home &
elif [[ $monitors == *"LVDS"* && $monitors == *"VGA"* ]]; then
    ~/bin/monitors.sh Work &
else
    nitrogen --restore &
    ~/bin/bar.sh &
fi

sxhkd -m 1 &

compton --config ~/.compton.conf &

dunst &

notifyd &

# make the cursor point in the 'right' direction
xsetroot -cursor_name left_ptr &

setxkbmap -model pc101 -layout us,bg -variant ,phonetic -option grp:alt_shift_toggle caps:escape &

urxvtd -q -f -o &

unclutter &

xautolock -notify 7 -notifier "pop \"locking screen...\"" -locker ~/bin/lock.sh -time 8 -killtime 15 -killer "systemctl suspend" -detectsleep -corners -000 &

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

exec xwait

