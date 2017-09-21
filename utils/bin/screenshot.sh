#!/usr/bin/bash

ES="Entire screen"
SA="Select Area"
CMD=`echo -e "$SA\n$ES" | rofi -dmenu -i -p "Capture Screen:"`
if [ ! "$CMD" ]; then
    exit
fi

FILE="/tmp/screenshot-$(date "+%F-%H_%M_%S").png"

case $CMD in
    $ES)
        sleep 0.3 && maim --hidecursor -d 1.0 -b 3 -c 0.3,0.4,0.6,0.4 --highlight $FILE 2>&1 ;;
    $SA)
        sleep 0.3 && maim --hidecursor -d 1.0 -s -b 3 -c 0.3,0.4,0.6,0.4 --highlight $FILE 2>&1 ;;
esac

if [ $? -eq 0 ]; then
    ~/bin/pop "Screenshot taken"
fi

~/bin/imgur-screenshot.sh $FILE

