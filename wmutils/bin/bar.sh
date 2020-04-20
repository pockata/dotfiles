#!/bin/bash
#
# bar - lemonbar output
#

# create status fifo
FIFO_PATH="/tmp/status.fifo"
test -e "$FIFO_PATH" && rm "$FIFO_PATH"
mkfifo "$FIFO_PATH"

GNUMBER=${GNUMBER:-5}
PANEL=${PANEL:-45}
BAR=${BAR:-30}

offset=$((PANEL - BAR))

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

    echo "${b_w}x${b_h}+$((mon_x + mon_w - b_w - offset))+$((mon_y + offset))"
}

showBar() {
    lemonbar -B "$color_bg" -F "$color_fg" -d -f "$b_f" -f "$b_fi" -g "$1"
}

#TODO: Add on-demand refresh support, e.g. `bar.sh -u "date"`

# clock
while :; do
    date=$(date "+%a %b %d %k:%M")
    # printf 'C%s' " $date"
    echo "C  $date"

    sleep 30s
done > "$FIFO_PATH" &

# groups
xprop -spy -root -notype \
-f _NET_ACTIVE_WINDOW '32x' '=$0\n' \
-f _NET_CURRENT_DESKTOP '32i' '=$0\n' \
-f _NET_CLIENT_LIST '32x' '=$0+\n' \
_NET_ACTIVE_WINDOW _NET_CURRENT_DESKTOP _NET_CLIENT_LIST | \
while read LINE; do
    case ${LINE} in
        _NET_CURRENT_DESKTOP*)
            _NET_CURRENT_DESKTOP=${LINE//*=/}
            ;;
        _NET_ACTIVE_WINDOW*)
            ;;
        _NET_CLIENT_LIST*)
            client_desktop_list=""
            _NET_CLIENT_LIST=${LINE//*=/}
            for client in ${_NET_CLIENT_LIST//,/}; do
                _NET_WM_DESKTOP=$(xprop -f _NET_WM_DESKTOP '32i' '=$0' -id ${client} -notype _NET_WM_DESKTOP)
                if [[ ${client_desktop_list} != *${_NET_WM_DESKTOP}* ]]; then
                    client_desktop_list="${client_desktop_list} ${_NET_WM_DESKTOP//*=/}"
                fi
            done
            ;;
    esac

    # Output desktop information
    output="G "

    for (( desktop=1; desktop <= $GNUMBER; desktop++ ))
    do
        c=$(color "$desktop")
        if (( desktop == _NET_CURRENT_DESKTOP )); then
            # current desktop
            output="${output}%{F$c}■%{F-} "
        else
            if [[ ${client_desktop_list} =~ ${desktop} ]]; then
                output="${output}%{F$c}□%{F-} "
            else
                output="${output}%{F#504945}□%{F-} "
            fi
        fi
    done
    echo -e "${output}"
done > "$FIFO_PATH" &

parseFifo() {
    line="$1"

        case $line in
            C*) clock="${line#?}" ;;
            G*) groups="${line#?}" ;;
        esac

        echo "$groups $clock"
}

mon1=$(echo "$monitors" | sed -n '1p')
b_geo1="$(barGeo "$mon1")"

if [ "$num_monitors" -gt 2 ]; then
    mon2=$(echo "$monitors" | sed -n '2p')
    mon3=$(echo "$monitors" | sed -n '3p')
    b_geo2="$(barGeo "$mon2")"
    b_geo3="$(barGeo "$mon3")"

    cat "$FIFO_PATH" | while read -r line; do
        parseFifo "$line"
    done |
        tee >(showBar "$b_geo1") |
        tee >(showBar "$b_geo2") |
        showBar "$b_geo3"

elif [ "$num_monitors" -gt 1 ]; then
    mon2=$(echo "$monitors" | sed -n '2p')
    b_geo2="$(barGeo "$mon2")"

    cat "$FIFO_PATH" | while read -r line; do
        parseFifo "$line"
    done |
        tee >(showBar "$b_geo1") |
        showBar "$b_geo2"
else
    cat "$FIFO_PATH" | while read -r line; do
        parseFifo "$line"
    done |
        showBar "$b_geo1"
fi

