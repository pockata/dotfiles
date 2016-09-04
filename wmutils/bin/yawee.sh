#!/bin/sh

PFW="$(pfw)"
[ -z "$CUR_WINDOW" ] && CUR_WINDOW="$PFW"

while IFS=: read ev wid; do

    case $1 in
        -d|--debug) printf '%s\n' "$ev $wid $PFW" ;;
    esac

    #if wattr o "$wid"; then
    #    continue;
    #fi

    PFW="$(pfw)"

    case $ev in

        # window creation
        16)
            if ! wattr o $wid; then
                ! wattr "$wid" || {
                    CUR_WINDOW="$wid"
                    corner_mh.sh md "$wid" ""
                }
            fi
            ;;

        #17)
        #    ~/bin/windows-fyrefree.sh -q -c "$(pfw)"
        #    ;;

        # mapping requests (show window)
        19)

            if ! wattr o $wid; then
                ! wattr "$wid" ||  {
                    CUR_WINDOW="$wid"
                    vroum.sh "$wid"
                }
            fi
            ;;

        # focus prev window when hiding(unmapping)/deleting focused window
        18)
            #(wattr "$(pfw)" && ! wattr m "$(pfw)") || {
            wattr "$PFW" || {
                vroum.sh prev 2>/dev/null
            }
            groups.sh > /dev/null
            ;;

        4)
            if ! wattr o $wid; then
                if [ "$wid" != "$CUR_WINDOW" ] && wattr "$wid"; then
                    CUR_WINDOW="$wid"
                    vroum.sh "$wid" &
                fi
            fi
            ;;
        #7) wattr o $wid || vroum.sh $wid ;;
    esac
done

