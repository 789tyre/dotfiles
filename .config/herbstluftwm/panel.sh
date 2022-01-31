#! /usr/bin/bash

# Kill already running bar instances
killall -q polybar

# echo "---" | tee -a /tmp/polybar1.log /tmp/polybar2.log
# polybar herbst 2>&1 | tee -a /tmp/polybar1.log & disown
# polybar herbst 2>&1 | tee -a /tmp/polybar2.log & disown

herbstclient pad ${1:-0} 20

if type "xrandr"; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload herbst &
        # MONITOR=$m xmobar /home/laptop/.config/xmobar/xmobar.config &
    done
else
    polybar --reload herbst &
fi

# echo "Bars launched..."
