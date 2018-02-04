#!/bin/bash
#
# z3bra - 2014 (c) wtfpl
# arrange windows in a tiled pattern

# get current window id and its borderwidth
PFW=$(pfw)
BW=$(wattr b $PFW)

direction=${1:-"left"}

# default values for gaps and master area
BAR=${BAR:-30}
GAP=${GAP:-15}
PANEL=${PANEL:-45}
# occupy 60% of the screen width
MASTER_AREA=${MASTER_AREA:-60}
MASTER=${MASTER:-$(echo "$(mattr w $PFW) * $MASTER_AREA / 100" | bc)}

# get current monitor's size
read SW SH SX SY = <<-eof
    $(mattr whxy $PFW)
eof

# get the windows in the current monitor
# TODO: simplify this. lsw -m <monitor id>?
WINDOWS=$(paste <(lsw | xargs mattr i) <(lsw) | grep -i $(mattr i $(pfw)) | awk '{ print $2; }' | grep -v $PFW)
MAX=$(echo "$WINDOWS" | wc -l)

# calculate usable screen size (without borders and gaps)
SW=$((SW - GAP - 2*BW))
SH=$((SH - GAP - PANEL))

Y=$((SY + GAP + PANEL))

MASTER_WIDTH=$((MASTER - GAP - 2*BW))

if [ $direction = "left" ]; then
    MASTER_X=$((SX + GAP))
else
    MASTER_X=$((SX + SW - MASTER_WIDTH))
fi

# put current window in master area
wtp $MASTER_X $Y $MASTER_WIDTH $((SH - GAP - 2*BW)) $PFW

# and now, stack up all remaining windows on the right
if [ $direction = "left" ]; then
    X=$((MASTER + GAP + SX))
else
    X=$((SX + GAP))
fi

W=$((SW - MASTER - GAP))
H=$((SH / MAX - GAP - 2*BW))

for wid in $WINDOWS; do
    wtp $X $Y $W $H $wid
    Y=$((Y + H + GAP + 2*BW))
done

