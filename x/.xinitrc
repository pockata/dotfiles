#!/bin/sh

[[ -f ~/.Xresources ]] && xrdb -load ~/.Xresources

sxhkd &

dunst &

# make the cursor point in the 'right' direction
xsetroot -cursor_name left_ptr &

rofi -key-window Mod4+w -key-run Mod4+d -modi "window,run"

setxkbmap -model pc101 -layout us,bg -variant ,phonetic -option grp:alt_shift_toggle caps:escape

urxvtd -q -f -o &

unclutter &

xautolock -locker ~/bin/lock.sh -time 7 -corners -000

redshift-gtk &

. ~/bin/wallpaper.sh
exec xwait

