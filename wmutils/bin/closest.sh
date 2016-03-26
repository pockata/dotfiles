#!/bin/sh
#
# closest - focus the closest window
# (c) ix & milsen 2016
#

usage() {
  echo "usage: $(basename $0) <direction>" >&2
  exit 1
}

CUR=$(pfw)

next() {
  lsw | xargs wattr "$1"i | sort -n"$2" | sed "0,/$CUR/d" | sed "1s/^[0-9]* //p;d"
}

case $1 in
  h|a|east|left)  focus.sh $(next x r)  2>/dev/null ;;
  j|s|south|down) focus.sh $(next y "") 2>/dev/null ;;
  k|w|north|up)   focus.sh $(next y r)  2>/dev/null ;;
  l|d|west|right) focus.sh $(next x "") 2>/dev/null ;;
  *) usage ;;
esac
