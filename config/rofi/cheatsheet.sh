#!/bin/sh

selection=$(rofi -i -p cheat -show-icons -opacity "90" -bw 1 -bc "$bg-color" -bg "$bg-color" -fg "$text-color" -hlbg "#42f4aa" -hlfg "#9575cd" -font "Ubuntu 15" -sidebar-mode -lines 20 -theme Arc-Dark -dmenu $@ < /home/lucio/.config/rofi/cheatsheet.txt)

selected=$(echo $selection)

echo -n "$selected" | xclip -selection clipboard

