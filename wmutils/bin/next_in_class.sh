#!/bin/sh

usage() {
    echo "usage: $(basename $0) <prev|next>"
    exit 1
}

test -z "$1" && usage

CUR=$(pfw)
CUR_CLASS=$(xprop -id $CUR WM_CLASS | cut -d\" -f2)
wids=$(lsw | xargs wattr xyi)

case $1 in
    next)
        wids=$(echo "$wids" | sort -nr) ;;

    prev)
        wids=$(echo "$wids" | sort -n) ;;

    *)
        usage ;;
esac

wids="$(echo "$wids" | sed "0,/$CUR/d")
$(echo "$wids" | sed "$,/$CUR/d")"

# I will die happy if I find a more elegant way of doing this.
windows=$(echo "$wids" | cut -d' ' -f3 | xargs -I{} sh -c 'echo "$(xprop -id {} WM_CLASS | cut -d\" -f2) {}"')
same_class=$(echo "$windows" | grep $CUR_CLASS)

wid=$(echo "$same_class" | head -1 | cut -d' ' -f2)
test -z $wid || vroum.sh $wid

