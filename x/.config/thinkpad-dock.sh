#!/bin/bash

## wait for the dock state to change
#sleep 0.5

USER="$(who | head -1 | awk '{ print $1 }')"
XAUTHORITY=/home/$USER/.Xauthority
DISPLAY=:0

export DISPLAY
export XAUTHORITY

if [[ "$ACTION" == "add" ]]; then
    DOCKED=1
elif [[ "$ACTION" == "remove" ]]; then
    DOCKED=0
else
    echo Please set env var \$ACTION to 'add' or 'remove'
    exit 1
fi

# invoke from XSetup with NO_KDM_REBOOT otherwise you'll end up in a KDM reboot loop
NO_KDM_REBOOT=0
for p in $*; do
    case "$p" in
        "NO_KDM_REBOOT") NO_KDM_REBOOT=1 ;;
        "SWITCH_TO_LOCAL") DOCKED=0 ;;
    esac
done

function switch_to_local {

    nmcli r wifi on

    /usr/bin/xrandr \
        --output HDMI1 --off \
        --output HDMI2 --off \
        --output HDMI3 --off \
        --output VGA1  --off \
        --output eDP2  --off \
        --output DP2  --off \
        --output LVDS1 --auto

}

function switch_to_external {

    nmcli r wifi off

    /usr/bin/xrandr \
        --output LVDS1 --off \
        --output VGA1 --mode 1680x1050 --pos 0x0 --rotate left

    sleep 1
    /home/pockata/.screenlayout/home.sh
}

case "$DOCKED" in
    "0")
        #undocked event
        logger -t DOCKED "undocked"
        switch_to_local ;;
    "1")
        #docked event
        logger -t DOCKED "docked"
        switch_to_external ;;
esac

/home/pockata/bin/setkeyboard.sh

