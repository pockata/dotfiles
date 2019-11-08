#!/bin/sh

while read ev wid args; do

    case $1 in
        -d|--debug) printf '%s\n' "$ev $wid $(pfw)" ;;
    esac

    case $ev in
        BUTTON_PRESS)
            if ! wattr o $wid; then
                wattr "$wid" && vroum.sh "$wid" "nowarp" &
            fi
            ;;

        CREATE)
            if ! wattr o $wid; then
                corner_mh.sh md "$wid"
            fi
            ;;

        MAP)
            if ! wattr o $wid; then
                    vroum.sh "$wid"
            fi
            ;;

        DESTROY)
            fullscreen_mh.sh "$wid" "clear"
            ;;

        # focus prev window when hiding(unmapping) focused window
        UNMAP)
            if ! wattr $(pfw); then
                vroum.sh prev "nowarp" 2>/dev/null
            fi
            groups.sh -C > /dev/null
            ;;
    esac
done

