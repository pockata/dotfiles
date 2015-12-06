#!/bin/sh
CMD=`echo -e "Lock\nLogout\nPoweroff\nReboot\nSuspend\nHibernate" | rofi -dmenu -i -p "Logout Menu:"`
if [ ! $CMD ]; then
    exit
fi

case $CMD in
    Logout)
        i3-msg exit ;;
    Lock)
        ~/bin/lock.sh ;;
    Poweroff)
        systemctl poweroff ;;
    Reboot)
        systemctl reboot ;;
    Suspend)
        systemctl suspend ;;
    Hibernate)
        systemctl hibernate ;;
esac
