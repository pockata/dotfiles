#!/bin/bash

# WIFI ICONS
# 

#ipnet=$(ip=$(/sbin/ifconfig | grep enp9s0 -A 5 | sed '/inet addr:/!d;s/.*addr:\([0-9.]*\).*/\1/'); if [ ! -z "$ip" ]; then echo "$ip"; else echo "No Connection";fi)

#ip=$(ip=$(/sbin/ifconfig | grep wlp3s0 -A 5 | sed '/inet\ addr/!d;s/.*addr:\([0-9.]*\).*/\1/'); if [ ! -z $ip ]; then echo $ip ;else ip=$(/sbin/ifconfig | grep eth0 -A 5 | sed '/inet addr:/!d;s/.*addr:\([0-9.]*\).*/\1/'); if [ ! -z "$ip" ]; then echo "$ip"; else echo "No ip";fi;fi)

ping=$(pn=$(timeout .8 ping 8.8.8.8 -c 1 -s 24 | sed '2!d;s/.*time=\([0-9]*\).*/\1/'); if [ -z $pn ] ; then echo "No Connection"; else echo "${pn}ms"; fi)

wifi=$(wf=$(iwgetid -r); if [ ${#wf} -lt 17 ]; then echo $wf; else echo "${wf:0:14}.."; fi);

sig=$(ds=$(iwconfig wlp3s0 | sed "s/\=/ /" | awk "/Link Quality/ { print \$3; }"); echo "$ds*100" | bc -l | sed "s/\..*//")

echo "${wifi} - ${sig}%/${ping}"
