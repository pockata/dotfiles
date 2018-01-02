#!/bin/sh

# [ -z "$CUR_WINDOW" ] && CUR_WINDOW="$(pfw)"

while IFS=: read ev wid; do

    case $1 in
        -d|--debug) printf '%s\n' "$ev $wid $(pfw)" ;;
    esac

    case $ev in

        # click on window
        4)
            if ! wattr o $wid; then
                wattr "$wid" && vroum.sh "$wid" "nowarp" &
            fi
            ;;

        # window creation
        16)
            if ! wattr o $wid; then
                corner_mh.sh md "$wid"
            fi
            ;;

        # mapping requests (show window)
        19)

            if ! wattr o $wid; then
                    vroum.sh "$wid"
            fi
            ;;

        17)
            fullscreen_mh.sh "$wid" "clear"
            ;;

        # focus prev window when hiding(unmapping) focused window
        18)
            if ! wattr $(pfw); then
                vroum.sh prev "nowarp" 2>/dev/null
            fi
            groups.sh -C > /dev/null
            ;;
    esac
done

