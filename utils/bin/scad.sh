#!/usr/bin/bash

NAME=${1:-"temp"}
NAME="${NAME}.scad"
FOLDER="${HOME}/Desktop/3D_Printing_Projects/OpenSCAD-designs"
FILENAME="${FOLDER}/${NAME}"

# ASK Helper
ask() {
  # http://djm.me/ask
  while true; do

    if [ "${2:-}" = "Y" ]; then
      prompt="Y/n"
      default=Y
    elif [ "${2:-}" = "N" ]; then
      prompt="y/N"
      default=N
    else
      prompt="y/n"
      default=
    fi

    # Ask the question
    read -p "$(echo -e "$1 [$prompt] ")" REPLY

    # Default?
    if [ -z "$REPLY" ]; then
       REPLY=$default
    fi

    # Check if the reply is valid
    case "$REPLY" in
      Y*|y*) return 0 ;;
      N*|n*) return 1 ;;
    esac

  done
}

if [ -f "$FILENAME" ]; then
    echo "The filename exists!"
    if ! ask "Open it?" N; then
        exit 1
    fi
fi

touch "$FILENAME"

if [ -f "$FILENAME" ]; then
    openscad "$FILENAME" &
    xdg-open "http://www.openscad.org/cheatsheet/index.html" &
    nvim "$FILENAME"
fi

