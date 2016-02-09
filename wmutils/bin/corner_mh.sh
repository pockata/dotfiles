#!/bin/sh

CUR=${2:-$(pfw)}
MON=$(mattr m ${3:-$(pfw)})
GAP=15
BAR=$((30 + GAP))

# exit if we can't find another window to focus
if ! wattr $CUR || test -z $MON; then
    echo "$(basename $0): no window to move $CUR" >&2;
    exit 1;
fi

SW=$(mattr w $MON)
SH=$(mattr h $MON)
SX=$(mattr x $MON)
SY=$(mattr y $MON)

BW=$(wattr b $CUR)
W=$(wattr w $CUR)
H=$(wattr h $CUR)

X="$SX"
Y="$SY"

case $1 in
    tl) X=$((X + GAP))
        Y=$((Y + BAR + GAP)) ;;
    tr) X=$((SX + SW - W - BW*2 - GAP))
        Y=$((Y + BAR + GAP)) ;;
    bl) X=$((X + GAP))
        Y=$((SY + SH - H - BW*2 - GAP)) ;;
    br) X=$((SX + SW - W - BW*2 - GAP))
        Y=$((SY + SH - H - BW*2 - GAP)) ;;
    md) X=$((SX + SW/2 - W/2 - BW))
        Y=$((SY + SH/2 - H/2 - BW));;
esac

wtp $X $Y $W $H $CUR

