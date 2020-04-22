#!/bin/dash

set -u

# load global WM vars
. ~/.wmrc

usage() {
    echo "usage: $(basename $0) <wid>"
    exit 1
}

# # exit if no argument given
# test -z "$1" && usage

win=${1:-$(pfw)}

GeometryAtom="WM_ORIGINAL_GEOMETRY"
MaximizedAtom="WM_MAXIMIZED"

# get current monitor's size
read MW MH MX MY <<-eof
    $(mattr whxy $win)
eof

getMaxGeometry() {
    ww="$((MW - LEFT_OFFSET - RIGHT_OFFSET - BW*2))"
    wh="$((MH - TOP_OFFSET - BOTTOM_OFFSET - BW*2))"
    wx="$((MX + LEFT_OFFSET))"
    wy="$((MY + TOP_OFFSET))"

    echo "$wx $wy $ww $wh"
}

storeOriginalGeometry() {
    win="$1"
    atomx "$GeometryAtom"="$(wattr xywh $win)" $win
}

getOriginalGeometry() {
    win="$1"
    echo "$(atomx $GeometryAtom $win)"
}

isMaximized() {
    win="$1"
    echo "$(atomx $MaximizedAtom $win)"
}

maxGeometry="$(getMaxGeometry $win)"

# if the window is marked as `maximized` and it hasn't been moved, restore it
# to the original geometry
if [ -n "$(isMaximized $win)" ] && [ "$(wattr xywh $win)" = "$maxGeometry" ]; then
    original="$(getOriginalGeometry $win)"
    wtp $original $win
    atomx -d $MaximizedAtom $win
else
    storeOriginalGeometry $win
    wtp $maxGeometry $win
    atomx $MaximizedAtom=1 $win
fi

