#!/usr/bin/bash

ES="Entire screen"
SA="Select Area"
CMD=`echo -e "$SA\n$ES" | rofi -dmenu -i -p "Capture Screen"`
if [ ! "$CMD" ]; then
    exit
fi

case $CMD in
    $ES)
        sleep 0.3 && flameshot full --path /tmp ;;
    $SA)
        sleep 0.3 && flameshot gui ;;
esac

# if [ $? -eq 0 ]; then
#     ~/bin/pop "Screenshot taken"
# fi

# ~/bin/imgur-screenshot.sh $FILE

