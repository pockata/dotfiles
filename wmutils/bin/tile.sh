#!/bin/bash
#
# z3bra - 2014 (c) wtfpl
# arrange windows in a tiled pattern

# get current window id and its borderwidth
PFW=$(pfw)
BW=$(wattr b $PFW)

# default values for gaps and master area
PANEL=${PANEL:-45}
GAP=${GAP:-15}
# occupy 60% of the screen width
MASTER=${MASTER:-$(echo "$(mattr w $PFW) * 60 / 100" | bc)}

# get current monitor's size
SW=$(mattr w $PFW)
SH=$(mattr h $PFW)
SX=$(mattr x $PFW)
SY=$(mattr y $PFW)

# get the windows in the current monitor
# TODO: simplify this. lsw -m <monitor id>?
WINDOWS=$(paste <(lsw | xargs mattr i) <(lsw) | grep -i $(mattr i $(pfw)) | awk '{ print $2; }' | grep -v $PFW)
MAX=$(echo "$WINDOWS" | wc -l)

# calculate usable screen size (without borders and gaps)
SW=$((SW - GAP - 2*BW))
SH=$((SH - GAP - PANEL))

Y=$((SY + GAP + PANEL))
# put current window in master area
wtp $((SX + GAP)) $Y $((MASTER - GAP - 2*BW)) $((SH - GAP - 2*BW)) $PFW

# and now, stack up all remaining windows on the right
X=$((MASTER + GAP + SX))
W=$((SW - MASTER - GAP))
H=$((SH / MAX - GAP - 2*BW))

for wid in $WINDOWS; do
    wtp $X $Y $W $H $wid
    Y=$((Y + H + GAP + 2*BW))
done

