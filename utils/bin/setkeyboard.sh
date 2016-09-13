#!/bin/sh -e

xset -b
setxkbmap -model pc101 -layout us,bg -variant ,phonetic -option grp:alt_shift_toggle caps:escape &

if ! xinput list --name-only | grep -qi "CM Storm Quickfire Rapid i"; then
    xset r rate 280 45
    # http://www.thinkwiki.org/wiki/How_to_configure_the_TrackPoint
    # enable trackpoint vertical scroll
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation" 1
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Button" 2
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Timeout" 200
    # horizontal scroll
    xinput set-prop "TPPS/2 IBM TrackPoint" "Evdev Wheel Emulation Axes" 6 7 4 5

    if command -v synclient >/dev/null 2>&1; then
        # disable touchpad
        synclient TouchpadOff=1
    fi
fi

