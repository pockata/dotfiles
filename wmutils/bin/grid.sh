#!/bin/dash
CUR=${1:-$(pfw)}

# monitor dimensions
read MX MY MWIDTH MHEIGHT <<-eof
    $(mattr xywh "$CUR")
eof

# window dimensions
read X Y WIDTH HEIGHT BW <<-eof
    $(wattr xywhb "$CUR")
eof

# WM layout
GAP=${GAP:-15}
PHEIGHT=${PHEIGHT:-45}

# move/resize
ACTION=${2:-"move"}
DIRECTION=${3:-"right"}

# grid size
HGRID=${5:-10}
VGRID=${4:-6}

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

case $ACTION in
    move)
        # available space
        HSPACE=$((MWIDTH - GAP*2 - BW*2))
        VSPACE=$((MHEIGHT - GAP*2 - BW*2))

        # column/row sizes
        HCOL=$((HSPACE / HGRID))
        VCOL=$((VSPACE / VGRID))

        case $DIRECTION in
            right)
                HNEXT=$(($(getQuotient "$X" "$HCOL") + 1))
                X="$((HNEXT * HCOL))"
                Y=0
                ;;

            left)
                HPREV=$(($(getQuotient "$X" "$HCOL") - 1))
                X="$((HPREV * HCOL))"
                Y=0
                ;;

            top)
                VPREV=$(($(getQuotient "$Y" "$VCOL") - 1))
                X=0
                Y="$((VPREV * VCOL))"
                ;;

            bottom)
                VNEXT=$(($(getQuotient "$Y" "$VCOL") + 1))
                X=0
                Y="$((VNEXT * VCOL))"
                ;;
            *) usage ;;
        esac

        wmv "$X" "$Y" "$CUR"

        ;;

    resize)
        # available space
        HSPACE=$((MWIDTH - X - GAP - BW))
        VSPACE=$((MHEIGHT - Y - GAP - BW))

        # column/row sizes
        HCOL=$((HSPACE / HGRID))
        VCOL=$((VSPACE / VGRID))

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
