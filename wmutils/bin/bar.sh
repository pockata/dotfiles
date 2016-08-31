#!/bin/bash
#
# bar - lemonbar output
#

GROOT=/tmp/groups
GNUMBER=5
GAP=${GAP:-15}

#~/bin/windows-fyrefree.sh -c >/dev/null

xrdb=$(xrdb -query)
color=($(echo "$xrdb" | grep -P "color[0-9]*:" | sort -m | cut -f 2-))
sp=($(echo "$xrdb" | grep -P "(foreground|background):" | cut -f 2-))

#       inactive    groups 1-5
colors=("${sp[0]}", "${color[1]}", "${color[2]}", "${color[3]}", "${color[4]}", "${color[5]}")

has_vga=$(mattr "VGA")
has_hdmi=$(mattr "HDMI")
has_lvds=$(mattr "LVDS")

if [ -z "$has_lvds" ]; then
    lvdsc=($(mattr wxy "LVDS"))
    mon1_w="${lvdsc[0]}"
    mon1_x="${lvdsc[1]}"
    mon1_y="${lvdsc[2]}"
fi

if [ -z "$has_vga" ]; then
    vgac=($(mattr wxy "VGA1"))
    mon2_w="${vgac[0]}"
    mon2_x="${vgac[1]}"
    mon2_y="${vgac[2]}"
fi

if [ -z "$has_hdmi" ]; then
    hdmic=($(mattr wxy "HDMI"))
    mon1_w="${hdmic[0]}"
    mon1_x="${hdmic[1]}"
    mon1_y="${hdmic[2]}"
fi

# bar dimensions
b_w=240
b_h=30

# bar fonts
b_f="Meslo LG M DZ for Powerline:style=regular:size=9"
b_fi="Font Awesome:style=regular:size=11"

# bar geometries
b_geo="${b_w}x${b_h}+$((mon1_x + mon1_w - b_w - GAP))+${GAP}"
b_geo2="${b_w}x${b_h}+$((mon2_x + mon2_w - b_w - GAP))+${GAP}"

desktop() {
    for gid in $(seq 1 $GNUMBER); do

        c=${colors[gid]}

        if [ ! -f "$GROOT/group.$gid" ]; then
            echo -n "%{F#504945}□%{F-} "
        else
            if grep --quiet "$gid" "$GROOT/active" 2>/dev/null; then
                echo -n "%{F$c}■%{F-} "
            else
                echo -n "%{F$c}□%{F-} "
            fi
        fi
    done
}

clock() {
  date=$(date "+%a %b %d %k:%M")
  printf '%s\n' " $date"
}

lemonize(){
  buf=""
  buf="${buf}$(desktop) $(clock)"
  printf '%s\n' "%{c}$buf"
  sleep 1
}

if [ -z "$has_vga" ] && [ -z "$has_hdmi" ]; then
    while :; do
        lemonize
    done |
        tee >(lemonbar -B "${sp[0]}" -F "${sp[1]}" -d -f "$b_f" -f "$b_fi" -g "$b_geo") |
        lemonbar -B "${sp[0]}" -F "${sp[1]}" -d -f "$b_f" -f "$b_fi" -g "$b_geo2"
else
    while :; do
        lemonize
    done |
        lemonbar -B "${sp[0]}" -F "${sp[1]}" -d -f "$b_f" -f "$b_fi" -g "$b_geo"
fi

