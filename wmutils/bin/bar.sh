#!/bin/bash
#
# bar - lemonbar output
# (c) arcetera 2015 - wtfpl
#

GROOT=/tmp/groups.sh
GNUMBER=5

groups.sh >/dev/null

colors=("#cc241d", "#98971a", "#d79921", "#458588", "#b16286")

has_vga=$(mattr "VGA")
has_hdmi=$(mattr "HDMI")
#if [ ! -z "$has_vga" ]; then
    vga_w=$(mattr w "VGA1")
    vga_x=$(mattr x "VGA1")
    vga_y=$(mattr y "VGA1")
#fi

#if [ ! -z "$has_hdmi" ]; then
    hdmi_w=$(mattr w "HDMI")
    hdmi_x=$(mattr x "HDMI")
    hdmi_y=$(mattr y "HDMI")
#fi

#if [ -z "$has_vga" ] || [ -z "$has_hdmi" ]; then
    lvds_w=$(mattr w "LVDS")
    lvds_x=$(mattr x "LVDS")
    lvds_y=$(mattr y "LVDS")
#fi

lm_w=240
lm_h=30

geometry="${lm_w}x${lm_h}+$((vga_x + vga_w - lm_w - 15))+15"
geometry2="${lm_w}x${lm_h}+$((hdmi_x + hdmi_w - lm_w - 15))+15"

echo "$geometry"
echo "$geometry2"

desktop() {
    for gid in $(seq 1 $GNUMBER); do

        c=${colors[$((gid - 1))]}

        if ! grep --quiet $gid "$GROOT/all"; then
            echo -n "%{F#504945}□%{F-} "
        else
            if grep --quiet $gid "$GROOT/active"; then
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

#lemonize() {
#    echo "$@" | lemonbar -B '#282828' -F '#ebdbb2' -d -f 'Meslo LG M DZ for Powerline:style=regular:size=9' -f 'Font Awesome:style=regular:size=11' -g "$geometry" &
#    echo "$@" | lemonbar -B '#282828' -F '#ebdbb2' -d -f 'Meslo LG M DZ for Powerline:style=regular:size=9' -f 'Font Awesome:style=regular:size=11' -g "$geometry2" &
#}

while :; do
  buf=""
  buf="${buf}$(desktop) $(clock)"
  printf '%s\n' "%{c}$buf"
  sleep 1
done |
#    tee >(lemonbar -B '#282828' -F '#ebdbb2' -d -f 'Meslo LG M DZ for Powerline:style=regular:size=9' -f 'Font Awesome:style=regular:size=11' -g "$geometry2") |
    lemonbar -B '#282828' -F '#ebdbb2' -d -f 'Meslo LG M DZ for Powerline:style=regular:size=9' -f 'Font Awesome:style=regular:size=11' -g "$geometry"

