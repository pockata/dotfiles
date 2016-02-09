#!/bin/sh

# handle multiple sequantial windows showing/hiding
# (when using groups)
prev_map=0
prev_unmap=0
tbuf=100000000

while IFS=: read ev wid; do
    # get the current time
    now=$(date +%s%N)

    case $ev in

        # window creation
        #16) wattr o $wid || corner_mh.sh md $wid $(pfw)

        # create window under cursor
        16) wattr o $wid || wmv -a $(wmp) "$wid"
            ;;

        # mapping requests (show window)
        19)
            if [ "$now" -le $((prev_map + tbuf)) ]; then
                continue;
            fi

            prev_map="$now"

            wattr o $wid || {
                vroum.sh $wid
            }
            ;;

        # focus prev window when hiding(unmapping)/deleting focused window
        18)
            if [ "$now" -le $((prev_unmap + tbuf)) ]; then
                continue;
            fi

            prev_unmap="$now"
            if ! wattr m $(pfw); then
                wattr o $wid || vroum.sh prev 2>/dev/null
            fi
            ;;

        4)
            echo "$wid $(pfw)"
            if [ "$wid" != "$(pfw)" ] && wattr $wid; then
                vroum.sh $wid &
            fi
            ;;
        #7) wattr o $wid || vroum.sh $wid ;;
    esac
done

