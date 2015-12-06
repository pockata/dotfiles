#!/usr/bin/bash

ES="Entire screen"
ESM="Entire screen (multimonitor)"
SA="Select Area"
CMD=`echo -e "$ES\n$ESM\n$SA" | rofi -dmenu -i -p "Capture Screen:"`
if [ ! $CMD ]; then
    exit
fi

case $CMD in
    $ES)
        ~/bin/imgur-screenshot.sh ;;
    $ESM)
        ~/bin/imgur-screenshot.sh ;;
esac

#notify-send -a "Scrot" "Screenshot taken"
