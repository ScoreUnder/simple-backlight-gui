#!/bin/bash
BL=( /sys/class/backlight/* )

if [ ! -w "${BL[0]}/brightness" ]; then
    if [ "$1" != "no-sudo" ]; then
        no_sudo() {
            zenity --warning --text="No sudo utility found -- install gksu or kdesu"
            exit
        }

        SUDO=no_sudo
        if which gksudo > /dev/null 2>&1; then SUDO=gksudo
        elif which kdesu > /dev/null 2>&1; then SUDO=kdesu
        fi

        exec $SUDO "$0" "no-sudo"
    fi

    zenity --error --text="Can't alter the brightness"
    exit
fi

MAXIMUM="$(<${BL[0]}/max_brightness)"
INITIAL="$(<${BL[0]}/brightness)"

while read val; do
    echo $val > "${BL[0]}/brightness"
done < <(zenity --scale --text="Set screen brightness" --min-value=0 --value="$INITIAL" --max-value="$MAXIMUM" --print-partial || echo "$INITIAL")
