#!env bash

set -e

file="/tmp/batko.html"
appimage="/tmp/slic3r.AppImage"

curl -L -o "$file" https://github.com/prusa3d/Slic3r/releases

link="https://github.com/$(cat "$file" | pup '.release:first-child .release-body a attr{href}' | grep -i 'appimage' | head -1)"

curl -L -o "$appimage" "$link"

sudo mv "$appimage" /opt/slic3r.AppImage
sudo chmod u+x /opt/slic3r.AppImage

cd /tmp/
rm -rf "$file"
rm -rf "$appimage"

