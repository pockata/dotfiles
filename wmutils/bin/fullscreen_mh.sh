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

# TODO: set this globally
GAP=15

# should we draw over the bar or not?
FSSIZE=${2:-"min"}

# this file is used to store the previous geometry of a window
FSFILE="/tmp/.fwin-$(printf '%q' "$1")"

# this will unset the fullscreen state of any fullscreen window if there is one.
# this way, there will only be one window in fullscreen at a time, and no window
# will loose their previous geometry info
#test -f $FSFILE && wtp $(cat $FSFILE)

setFull() {
    # put the current window in fullscreen mode,
    # after saving it's geometry and id to $FSFILE
    BW=$(wattr b $1)

    # the height of the bar
    BH=$((30 + GAP))

    if [ "$FSSIZE" = "max" ]; then
        BH=0;
        GAP=0
    fi

    if [ "$2" = "save" ]; then
        echo "$(wattr xywhi $1) $FSSIZE" > $FSFILE
    fi

    #test "$2" = "save" && echo "$(wattr xywhi $1) $FSSIZE" > $FSFILE
    mon=($(mattr whxy $1))

    ww=$((mon[0] - BW*2 - GAP*2))
    wh=$((mon[1] - BW*2 - BH - GAP*2))
    wx=$((mon[2] + GAP))
    wy=$((mon[3] + BH + GAP))
    wtp $wx $wy $ww $wh $1
}

setOrig() {
    wtp $(cat $FSFILE | sed 's/ max//g;s/ min//g')
    rm -f $FSFILE
}

# if file exist and contain our window id, it means that out window is in
# fullscreen mode
if test -f $FSFILE; then
    # if the window we removed was our window, delete the file, so we can
    # fullscreen it again later
    if grep -q "max" $FSFILE; then
        if [ $FSSIZE = 'max' ]; then
            setOrig
        else
            setFull $1
            sed -i "s/max/min/g" $FSFILE
        fi
    else
        echo "2:$FSSIZE"
        if [ $FSSIZE = 'max' ]; then
            setFull $1
            sed -i "s/min/max/g" $FSFILE
        else
            setOrig
        fi
    fi

else
    setFull $1 save
fi

# now focus the window, and put it in front, no matter which state we're in, and
vroum.sh $1

