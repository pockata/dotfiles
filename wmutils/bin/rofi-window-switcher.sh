#!/bin/bash

declare -A windows
CMD=""

while read wid; do
    name=$(xprop -id $wid WM_NAME | cut -d\" -f2)
    class=$(xprop -id $wid WM_CLASS | cut -d\" -f4)

    str="$class - $name"
    CMD="$CMD$str\n"

    windows[$str]=$wid
done <<< "$(lsw)"

# trim the output
CMD=$(echo -e "$CMD" | sed 's/.*\n+$//g')

rf=`echo -e "$CMD" | rofi -dmenu -i -p "Switch to Window:"`

vroum.sh ${windows[$rf]}

