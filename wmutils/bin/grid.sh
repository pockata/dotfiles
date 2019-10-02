#!/bin/dash
CUR=${1:-$(pfw)}

# monitor dimensions
read MX MY MWIDTH MHEIGHT <<-eof
    $(mattr xywh "$CUR")
eof

# window dimensions
read OX OY WIDTH HEIGHT BW <<-eof
    $(wattr xywhb "$CUR")
eof

# WM layout
GAP=${GAP:-15}
PHEIGHT=${PHEIGHT:-45}

# move/resize
ACTION=${2:-"move"}
DIRECTION=${3:-"right"}

# TODO: Change to grid location and move grid size to ENV variable
# grid size
HGRID=${5:-10}
VGRID=${4:-6}

# set min/max boundaries
HMIN="$((GAP))"
HMAX="$((MWIDTH - WIDTH - GAP*2))"
VMIN="$((PHEIGHT + GAP))"
VMAX="$((MHEIGHT - HEIGHT - GAP*2))"

# adjust coords to start from the top left corner of the current monitor
X="$((OX - MX))"
Y="$((OY - MY))"

getQuotient() {
    WIN=$1
    SPACE=$2
    rawQuotient=$((WIN / SPACE))
    remainder=$((rawQuotient % 1))
    quotient=$((rawQuotient - remainder))

    echo "$quotient"
}

usage() {
    echo "WAT"
}

# available space
HSPACE=$((MWIDTH - GAP*2 - BW*2))
VSPACE=$((MHEIGHT - GAP*2 - BW*2))

# column/row sizes
HCOL=$((HSPACE / HGRID))
VCOL=$((VSPACE / VGRID))

NEW_X="$X"
NEW_Y="$Y"

case $ACTION in
    move)
        case $DIRECTION in
            right)
                HNEXT=$(($(getQuotient "$X" "$HCOL") + 1))
                NEW_X="$((HNEXT * HCOL))"
                ;;

            left)
                HPREV=$(($(getQuotient "$X" "$HCOL") - 1))
                NEW_X="$((HPREV * HCOL))"
                ;;

            top)
                VPREV=$(($(getQuotient "$Y" "$VCOL") - 1))
                NEW_Y="$((VPREV * VCOL))"
                ;;

            bottom)
                VNEXT=$(($(getQuotient "$Y" "$VCOL") + 1))
                NEW_Y="$((VNEXT * VCOL))"
                ;;
            *) usage ;;
        esac

        # apply min/max boundaries to the new coordinates
        NEW_X="$((NEW_X < HMIN ? HMIN : NEW_X))"
        NEW_X="$((NEW_X > HMAX ? HMAX : NEW_X))"

        NEW_Y="$((NEW_Y < VMIN ? VMIN : NEW_Y))"
        NEW_Y="$((NEW_Y > VMAX ? VMAX : NEW_Y))"

        echo "$HMIN $HMAX $VMIN $VMAX"
        echo "$X $Y $WIDTH $HEIGHT"
        echo "$HSPACE $VSPACE"
        echo "$HCOL $VCOL"
        echo "$NEW_X $NEW_Y"

        # wmv takes relative coords so calculate the difference
        wmv "$((NEW_X - X))" "$((NEW_Y - Y))" "$CUR"

        ;;

    resize)
        case $DIRECTION in
            right)
                HNEXT=$(($(getQuotient "$WIDTH" "$HCOL") + 1))
                X="$((HNEXT * HCOL - WIDTH))"
                Y=0
                ;;

            left)
                HPREV=$(($(getQuotient "$WIDTH" "$HCOL") - 1))
                X="$((HPREV * HCOL - WIDTH))"
                Y=0
                ;;

            top)
                VPREV=$(($(getQuotient "$HEIGHT" "$VCOL") - 1))
                X=0
                Y="$((VPREV * VCOL - HEIGHT))"
                ;;

            bottom)
                VNEXT=$(($(getQuotient "$HEIGHT" "$VCOL") + 1))
                X=0
                Y="$((VNEXT * VCOL - HEIGHT))"
                ;;
            *) usage ;;
        esac

        wrs "$X" "$Y" "$CUR"

        ;;
esac
