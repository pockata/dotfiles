#!/bin/dash
#
# closest_mon - move window to the closest monitor
#

usage() {
    echo "usage: $(basename $0) <direction>" >&2
    exit 1
}

PFW=$(pfw)
MON=$(mattr n $PFW)
GAP=${GAP:-15}
BAR=${BAR:-30}

next() {
    lsm | xargs mattr i"$1" | uniq -f1 -u | sort -k2 -n"$2" | awk '{ print $2, $1; }' | sed "0,/$MON/d" | sed "1s/^[0-9]* //p;d"
}

move_to_mon() {

    test -z $1 && return

    corner_mh.sh md $PFW $1

    w=$(wattr w $PFW)
    h=$(wattr h $PFW)

    mw=$(mattr w $1)
    mh=$(mattr w $1)

    vert_space=$((mw - BAR - GAP*3))
    horiz_space=$((mh - GAP*2))

    if [ "$w" -gt "$horiz_space" ] || [ "$h" -gt "$vert_space" ]; then
        fullscreen_mh.sh $PFW
    fi
}

case $1 in
    h|a|east|left)  move_to_mon $(next x r)  2>/dev/null ;;
    j|s|south|down) move_to_mon $(next y "") 2>/dev/null ;;
    k|w|north|up)   move_to_mon $(next y r)  2>/dev/null ;;
    l|d|west|right) move_to_mon $(next x "") 2>/dev/null ;;
    *) usage ;;
esac

