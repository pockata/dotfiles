#!/bin/sh

[ -z "$CUR_WINDOW" ] && CUR_WINDOW="$(pfw)"

while IFS=: read ev wid; do

    case $1 in
        -d|--debug) printf '%s\n' "$ev $wid $(pfw)" ;;
    esac

    case $ev in

        # window creation
        16)
            if ! wattr o $wid; then
                ! wattr "$wid" || {
                    CUR_WINDOW="$wid"
                    corner_mh.sh md "$wid"
                }
            fi
            ;;

        # mapping requests (show window)
        19)

            if ! wattr o $wid; then
                ! wattr "$wid" ||  {
                    CUR_WINDOW="$wid"
                    vroum.sh "$wid"
                }
            fi
            ;;

        17)
            fullscreen_mh.sh "$wid" "clear"
            ;;

        # focus prev window when hiding(unmapping)/deleting focused window
        18)
            #(wattr "$(pfw)" && ! wattr m "$(pfw)") || {
            #wattr "$(pfw)" || {
                #vroum.sh prev 2>/dev/null
                vroum.sh "$(lsw | tail -1)" 2>/dev/null
            #}
            groups.sh > /dev/null
            ;;
    esac
done

