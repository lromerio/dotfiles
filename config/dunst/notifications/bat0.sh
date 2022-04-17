#!/bin/sh

# Thresholds
FULL=94
LOW=20
CRITICAL=10
HIBERNATE=5

# Get battery status
CAPACITY=$(cat /sys/class/power_supply/BAT0/capacity)
STATUS=$(cat /sys/class/power_supply/BAT0/status)

# Battery discharging and low
if [ "$STATUS" = "Discharging" ] && [ "$CAPACITY" -lt "$LOW" ]; then
    if [ "$CAPACITY" -lt "$HIBERNATE" ]; then
        i3lock --show-failed-attempts --color='#2f343f' --ignore-empty-password && sudo systemctl hibernate

    elif [ "$CAPACITY" -lt "$CRITICAL" ]; then
        /usr/bin/notify-send -u critical -a power_supply_low "Out of Battery" "Running out of battery ($CAPACITY%)\nPLUG THE CHARGER!!!"
    else
        /usr/bin/notify-send -t 100000 -u normal -a power_supply_low "Low Battery" "Running low ($CAPACITY%)\nPlug the charger!"
    fi
    # echo "Low Battery notification sent" && $(paplay .config/dunst/notifications/sounds/clearly.ogg) || \

# Battery charging and fully charged
elif [ "$STATUS" != "Discharging" ] && [ "$CAPACITY" -gt "$FULL" ]; then
    echo "FULL"
    /usr/bin/notify-send -u normal -a power_supply_full "Battery Full" "Fully charged ($CAPACITY%)\nUNPLUG!"
    # echo "Full Battery notification sent" && $(paplay .config/dunst/notifications/sounds/clearly.ogg) || \

fi
