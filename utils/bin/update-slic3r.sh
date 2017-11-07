#!env bash

set -e

file="/tmp/batko.html"

curl -o "$file" https://dl.slic3r.org/dev/linux/

link="https://dl.slic3r.org/dev/linux/$(cat "$file" | pup '#indexlist .indexcolname a attr{href}' | grep -i 'appimage' | head -1)"

curl -o /tmp/slic3r.AppImage "$link"

sudo mv /tmp/slic3r.AppImage /opt/slic3r.AppImage
sudo chmod u+x /opt/slic3r.AppImage

