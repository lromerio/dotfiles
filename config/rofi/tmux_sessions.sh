#! /usr/bin/env bash

function tmux_sessions()
{
    tmux list-session -F '#S'
}

TMUX_SESSION=$( (echo new; tmux_sessions) | rofi -dmenu -p "tmux" -show-icons -opacity "90" -bw 1 -bc "$bg-color" -bg "$bg-color" -fg "$text-color" -hlbg "#42f4aa" -hlfg "#9575cd" -font "Ubuntu 15" -sidebar-mode -lines 20 -theme Arc-Dark -dmenu)

if [[ x"new" = x"${TMUX_SESSION}" ]]; then
        alacritty -e tmux new-session &
    elif [[ -z "${TMUX_SESSION}" ]]; then
        echo "Cancel"
    else
        alacritty -e tmux attach -t "${TMUX_SESSION}" &
fi

