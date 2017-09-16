#!/bin/sh
#
# z3bra - 2014 (c) wtfpl
# toggle the fullscreen state of a window
# depends on: focus.sh

# it's pretty simple, but anyway...
usage() {
    echo "usage: $(basename $0) <wid> [max]"
    exit 1
}

# exit if no argument given
test -z "$1" && usage

GAP=${GAP:-15}

# should we draw over the bar or not?
FSSIZE=${2:-"min"}

win="$1"
# this file is used to store the previous geometry of a window
FSFILE="/tmp/.fwin-$(printf '%q' "$win")"

# clear leftover files
if [ $FSSIZE = "clear" ]; then
    if [ -f "$FSFILE" ]; then
        rm "$FSFILE"
    fi
    exit
fi

# this will unset the fullscreen state of any fullscreen window if there is one.
# this way, there will only be one window in fullscreen at a time, and no window
# will loose their previous geometry info
#test -f $FSFILE && wtp $(cat $FSFILE)

getFullCoords() {
    BW=$(wattr b $1)

    # the height of the bar
    BH=$((30 + GAP))

    if [ "$FSSIZE" = "max" ]; then
        BH=0;
        GAP=0
    fi

    mon=($(mattr whxy $1))

    ww=$((mon[0] - BW*2 - GAP*2))
    wh=$((mon[1] - BW*2 - BH - GAP*2))
    wx=$((mon[2] + GAP))
    wy=$((mon[3] + BH + GAP))

    echo $wx $wy $ww $wh
}

setFull() {
    # put the current window in fullscreen mode,
    wtp $(getFullCoords $1) $1
}

setOrig() {
    wtp $(cat $FSFILE | sed 's/ max//g;s/ min//g')
    rm -f $FSFILE
}

# if file exist and contain our window id, it means that out window is in
# fullscreen mode
if test -f $FSFILE; then

    if [ "$(getFullCoords $win)" != "$(wattr xywh $win)" ]; then

        if [ "$FSSIZE" == "max" ]; then
            sed -i "s/min/max/g" $FSFILE
        else
            sed -i "s/max/min/g" $FSFILE
        fi

        setFull $win
        exit
    fi

    hasMax=$(grep -c "max" $FSFILE)

    if [ "$hasMax" -ne 0 ] && [ "$FSSIZE" != "max" ]; then
        setFull $win
        sed -i "s/max/min/g" $FSFILE
    elif [ "$hasMax" -eq 0 ] && [ "$FSSIZE" = "max" ]; then
        setFull $win
        sed -i "s/min/max/g" $FSFILE
    else
        setOrig
    fi
else
    # save window's geometry and id to $FSFILE
    echo "$(wattr xywhi $win) $FSSIZE" > $FSFILE
    setFull $win
fi

# now focus the window, and put it in front, no matter which state we're in, and
vroum.sh $win

