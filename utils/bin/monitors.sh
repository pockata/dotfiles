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
    "Auto")
        xrandr --auto ;;
    *)
        echo "Usage:" ;;
esac

# Always set the wallpaper after xrandr changes
nitrogen --restore &

# Get the primary monitor (if specified) or use the widest one
primaryMonitor=$(lsm -p || lsm | xargs mattr iwh | sort -k2 -r | head -1 | awk '{ print $1 }')

# Move all windows that are outside of the new arrangement into the primary
# monitor
for WINDOW in $(lsw)
do
    mattr i "$WINDOW" > /dev/null 2>&1 || closest_mon.sh "specific" "$WINDOW" "$primaryMonitor"
done

# Restart the bar
# TODO: Find a way to improve it
kill -9 `pgrep lemonbar` &> /dev/null
. ~/bin/bar.sh &> /dev/null &

exit 0

