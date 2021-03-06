#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# focus windows by positions
# depends on: vroum

# get current window id
CUR=$(pfw)

usage() {
    echo "usage: $(basename $0) <east|west|north|south>"
    exit 1
}

#echo "$foo" | awk -v cx="$center_x" -v cy="$center_y" '{
#    printf "%d %d %s\n", $1/2+$3, $2/2+$4, $5
#}'
next_east() {
    lsw | xargs wattr xwi | awk '{ print $1+$2/2, $3 }' | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9\.]* //p;d"
}

next_west() {
    lsw | xargs wattr xwi | awk '{ print $1+$2/2, $3 }' | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9\.]* //p;d"
}

next_north() {
    lsw | xargs wattr yhi | awk '{ print $1+$2/2, $3 }' | sort -nr | sed "0,/$CUR/d" | sed "1s/^[0-9\.]* //p;d"
}

next_south() {
    lsw | xargs wattr yhi | awk '{ print $1+$2/2, $3 }' | sort -n | sed "0,/$CUR/d" | sed "1s/^[0-9\.]* //p;d"
}

case $1 in
    h|a|east|left)  vroum.sh $(next_east)  2>/dev/null ;;
    j|s|south|down) vroum.sh $(next_south) 2>/dev/null ;;
    k|w|north|up)   vroum.sh $(next_north) 2>/dev/null ;;
    l|d|west|right) vroum.sh $(next_west)  2>/dev/null ;;
esac

