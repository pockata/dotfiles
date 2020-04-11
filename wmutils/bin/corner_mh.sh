#!/bin/dash

GAP=${GAP:-15}
BAR=${BAR:-30}

CUR=${2:-$(pfw)}
ANCHOR=${3:-$(pfw)}

# exit if we can't find another window to move
if ! wattr $CUR; then
    echo "$(basename $0): no window to move $CUR" >&2;
    exit 1;
fi

# if there's no anchor to use, use the root window
# this way we use the monitor with most pixels
if ! wattr $ANCHOR && ! mattr $ANCHOR; then
    ANCHOR=$(lsw -r)
fi

SW=$(mattr w $ANCHOR)
SH=$(mattr h $ANCHOR)
SX=$(mattr x $ANCHOR)
SY=$(mattr y $ANCHOR)

BW=$(wattr b $CUR)
W=$(wattr w $CUR)
H=$(wattr h $CUR)

X="$SX"
Y="$SY"

case $1 in
    tl) X=$((X + GAP))
        Y=$((Y + BAR + GAP*2)) ;;
    tr) X=$((SX + SW - W - BW*2 - GAP))
        Y=$((Y + BAR + GAP*2)) ;;
    bl) X=$((X + GAP))
        Y=$((SY + SH - H - BW*2 - GAP)) ;;
    br) X=$((SX + SW - W - BW*2 - GAP))
        Y=$((SY + SH - H - BW*2 - GAP)) ;;
    md) X=$((SX + SW/2 - W/2 - BW))
        Y=$((SY + SH/2 - H/2 - BW))
        test "$Y" -lt $((BAR + GAP*2)) && Y=$((BAR + GAP*2))
        ;;
esac

wtp $X $Y $W $H $CUR

# Move the pointer to the center of the window
wmp -a $(wattr xywh $CUR | awk '{ print $1+$3/2, $2+$4/2 }')

