#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

sxhkd -c ~/keybindings.conf > /dev/null 2>&1 &

dunst -config ~/.dunstrc &

rofi -key-window Mod4+w -key-run Mod4+d -modi "window,run"

setxkbmap -model pc101 -layout us,bg -variant ,phonetic -option grp:alt_shift_toggle caps:escape

urxvtd -q -f -o &

unclutter &

xautolock -locker ~/bin/lock.sh -time 7 -corners -000

redshift-gtk &

exec swm
