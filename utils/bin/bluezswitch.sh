#!/bin/dash

BLUEZCARD=`pactl list cards short | grep "bluez.*[[:space:]]" | awk -F" " '{print $1;}'`
pactl set-card-profile $BLUEZCARD a2dp_sink
pactl set-card-profile $BLUEZCARD off
pactl set-card-profile $BLUEZCARD a2dp_sink

