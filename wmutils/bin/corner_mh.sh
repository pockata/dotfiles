#!/bin/sh

GAP=15
BAR=$((30 + GAP))

CUR=${2:-$(pfw)}
ANCHOR=${3:-$CUR}

# exit if we can't find another window to move
if ! wattr $CUR; then
    echo "$(basename $0): no window to move $CUR" >&2;
    exit 1;
fi

# if there's no anchor to use, use the root window
# this way we use the monitor with most pixels
if ! wattr $ANCHOR; then
    ANCHOR=$(lsw -r)
fi

MON=($(mattr whxy $ANCHOR))

SW=${MON[0]}
SH=${MON[1]}
SX=${MON[2]}
SY=${MON[3]}

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

