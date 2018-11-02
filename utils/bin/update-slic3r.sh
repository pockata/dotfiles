#!env bash

set -e

file="/tmp/batko.html"
appimage="/tmp/slic3r.AppImage"

install_slicer() {
    appimage="$1"
    link="$2"

    curl -L -o "$appimage" "$link"

    sudo mv "$appimage" /opt/slic3r.AppImage
    sudo chmod u+x /opt/slic3r.AppImage

    cd /tmp/
    rm -rf "$file"
    rm -rf "$appimage"

}

echo ""
echo "Fetching latest release version..."
echo ""

curl -L -o "$file" https://github.com/prusa3d/Slic3r/releases

link="https://github.com/$(cat "$file" | pup '.release:first-child .Details-element a attr{href}' | grep -i 'appimage' | head -1)"

echo ""
echo "Link for download: "
echo "$link"
echo ""

while true; do
    read -p "Do you wish to install this release? " yn
    echo ""
    case $yn in
        [Yy]* ) install_slicer "$appimage" "$link"; break;;
        [Nn]* ) exit;;
        * ) echo "Please answer yes or no.";;
    esac
done

