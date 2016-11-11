#!/bin/bash
#
# bar - lemonbar output
#

GROOT=/tmp/groups.sh
GNUMBER=5
GAP=${GAP:-15}
BAR=${BAR:-30}

monitors="$(lsm)"
num_monitors=$(echo "$monitors" | wc -l)

# bar dimensions
b_w=240
b_h="$BAR"

# bar fonts
b_f="Meslo LG M DZ for Powerline:style=regular:size=9"
b_fi="Font Awesome:style=regular:size=11"

xrdb="$(xrdb -query)"
xcolors="$(echo "$xrdb" | grep -P "\*color[0-9]*:" | sed 's/\*color//' | sort -n -k1,1 | cut -f 2-)"
color_fg=$(echo "$xrdb" | grep -P "foreground:" | cut -f 2-)
color_bg=$(echo "$xrdb" | grep -P "background:" | cut -f 2-)

xcolor() {
    echo "$xcolors" | sed -n "$1p"
}

color() {
    echo "$colors" | sed -n "$1p"
}

colors="$(xcolor 2)
$(xcolor 3)
$(xcolor 4)
$(xcolor 5)
$(xcolor 6)"

barGeo() {
    mon_x="$(mattr x $1)"
    mon_y="$(mattr y $1)"
    mon_w="$(mattr w $1)"

    echo "${b_w}x${b_h}+$((mon_x + mon_w - b_w - GAP))+$((mon_y + GAP))"
}

desktop() {
    for gid in $(seq 1 $GNUMBER); do

        c=$(color "$gid")

        if ! grep --quiet "$gid" "$GROOT/all"; then
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

mon1=$(echo "$monitors" | sed -n '1p')
b_geo1="$(barGeo "$mon1")"

if [ "$num_monitors" -gt 2 ]; then
    mon2=$(echo "$monitors" | sed -n '2p')
    mon3=$(echo "$monitors" | sed -n '3p')
    b_geo2="$(barGeo "$mon2")"
    b_geo3="$(barGeo "$mon3")"

    while :; do
        lemonize
    done |
        tee >(lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo1") |
        tee >(lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo2") |
        lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo3"
elif [ "$num_monitors" -gt 1 ]; then
    mon2=$(echo "$monitors" | sed -n '2p')
    b_geo2="$(barGeo "$mon2")"

    while :; do
        lemonize
    done |
        tee >(lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo1") |
        lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo2"
else
    while :; do
        lemonize
    done |
        lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$b_geo1"
fi

