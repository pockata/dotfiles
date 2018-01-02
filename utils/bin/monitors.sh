#!/usr/bin/bash
he="Home [eGPU]"
h="Home"
w="Work"
a="aRandR"

if [ ! -z "$1" ]; then
    CMD="$1"
else
    CMD=`echo -e "$h\n$he\n$w\n$a" | rofi -dmenu -i -p "Monitor Setup:"`
fi

if [ ! "$CMD" ]; then
    exit
fi

case $CMD in
    "$w")
        ~/.screenlayout/work.sh ;;
    "$h")
        ~/.screenlayout/home.sh ;;
    "$he")
        ~/.screenlayout/home-egpu.sh ;;
    "$a")
        arandr ;;
    *)
        echo "Usage:" ;;
esac

# Always set the wallpaper after xrandr changes
xsetroot -bitmap ~/.config/tile.xbm -bg "$(xrdb -query | grep "*color8" | awk '{print $2}')" -fg "$(xrdb -query | grep "*color0" | awk '{print $2}')"

# Restart the bar
# TODO: Find a way to improve it
kill -9 `pgrep lemonbar` &> /dev/null
. ~/bin/bar.sh &> /dev/null &

exit 0

