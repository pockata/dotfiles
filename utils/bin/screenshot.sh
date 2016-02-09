#!/usr/bin/bash

ES="Entire screen"
SA="Select Area"
CMD=`echo -e "$ES\n$SA" | rofi -dmenu -i -p "Capture Screen:"`
if [ ! "$CMD" ]; then
    exit
fi

FILE="/tmp/screenshot-$(date "+%F-%H_%M_%S").png"

case $CMD in
    $ES)
        sleep 0.3 && maim --hidecursor -d 1.0 -b 3 -c 250,250,250 $FILE 2>&1 ;;
    $SA)
        sleep 0.3 && maim --hidecursor -d 1.0 -s -b 3 -c 250,250,250 $FILE 2>&1 ;;
esac

notify-send -a "Scrot" "Screenshot taken"

~/bin/imgur-screenshot.sh $FILE

notify-send -a "Scrot" "Screenshot uploaded"

