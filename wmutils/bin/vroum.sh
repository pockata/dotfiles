#!/bin/sh
# z3bra - 2014 (c) wtfpl
# window focus wrapper that sets borders and can focus next/previous window

BW=${BW:-6}                    # border width
ACTIVE=${ACTIVE:-0x87404f}     # active border color
INACTIVE=${INACTIVE:-0x323232} # inactive border color

# get current window id
CUR=$(pfw)

usage() {
    echo "usage: $(basename $0) <next|prev|wid>" >&2
    exit 1
}

setborder() {
    #ROOT=$(lsw -r)

    # check that window exists and shouldn't be ignored
    wattr $2 || return
    wattr o $2 && return

    # do not modify border of fullscreen windows
    #test "$(wattr xywh $2)" = "$(wattr xywh $ROOT)" && return

    case $1 in
        active)
            chwb -s $BW -c $ACTIVE $2
            #chwb2 -O $ACTIVE -I 000000 -i 4 -o 4 $2
            ;;
        inactive)
            chwb -s $BW -c $INACTIVE $2
            #chwb2 -O $INACTIVE -I 000000 -i 4 -o 4 $2
            ;;
    esac
}

case $1 in
    next)
        wid=$(lsw|grep -v "$CUR"|sed '1 p;d')
        ;;
    prev)
        wid=$(lsw|grep -v "$CUR"|sed '$ p;d')
        ;;
    0x*) wattr $1 && wid=$1 ;;
    *) usage ;;
esac

# exit if we can't find another window to focus
test -z "$wid" && { echo "$(basename $0): no window to focus $1" >&2; exit 1; }

# sometimes something fucks up,
# and there are two windows with active borders
# this "fixes" it
lsw | grep -v "$wid" | xargs chwb -s $BW -c $INACTIVE
#setborder inactive $CUR
setborder active $wid   # activate the new window
chwso -r $wid           # raise windows
wtf $wid                # set focus on it

xdotool search --class "Dunst" windowraise

