#!/usr/bin/bash
h="Home"
h2="Home (2 monitors)"
w="Work"
wi="Work (inverted)"
a="aRandR"
CMD=`echo -e "$h\n$h2\n$w\n$wi\n$a" | rofi -dmenu -i -p "Monitor Setup:"`
if [ ! $CMD ]; then
    exit
fi

case $CMD in
    $w)
        ~/.screenlayout/work.sh ;;
    $wi)
        ~/.screenlayout/work-inverted.sh ;;
    $h)
        ~/.screenlayout/home.sh ;;
    $h2)
        ~/.screenlayout/home-2monitors.sh ;;
    $a)
        arandr ;;
esac

# Always set the wallpaper after xrandr changes
. ~/bin/wallpaper.sh

