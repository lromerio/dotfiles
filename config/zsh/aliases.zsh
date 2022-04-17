#!/usr/bin/env zsh

# editor
alias vim='nvim'
alias vi='nvim'

# tmux
alias tn='tmux new -s'
alias ta='tmux attach -t'
alias ts='tmux ls'

# Notification
alias ddone='notify-send "DONE"'

# Screenshoots
alias sc='scrot -o -z -s'
alias scw='scrot -o -u -d 2 -s'

# Wifi
alias wifidown='sudo ip link set wlan0 down'
alias home='sudo netctl switch-to Paradise\ Falls'
alias ticino='sudo netctl switch-to casa_ticino'
alias phone='sudo netctl switch-to pwndawan_phone'
alias epfl='sudo netctl switch-to eduroam'

# ctf
alias ctf='cd ~/ctf/2022'
alias sploit='cp ~/ctf/tools/docker/exploit.py'

# Command line pipe shortcuts
alias -g H='| head'
alias -g T='| tail'
alias -g G='| grep'
alias -g R='| rg -i -e'
alias -g L="| less"
alias -g C="| wc -l"

# Find files
alias ff='fd -t f'
alias ffd='fd -t d'
alias ffe='fd -t f -e'

# Misc
alias xopen="xdg-open"
alias ptop="sudo powertop"

# Ip
alias ipa='ip -c=always a s'

## use delete key to delete
bindkey "^[[3~"  delete-char
bindkey "^[3;5~" delete-char
## shift+tab backward menu key
bindkey '^[[Z' reverse-menu-complete

## home and end keys
bindkey "${terminfo[khome]}" beginning-of-line
bindkey "${terminfo[kend]}" end-of-line
bindkey "\033[1~" beginning-of-line
bindkey "\033[4~" end-of-line

# Make zsh know about hosts already accessed by SSH
zstyle -e ':completion:*:(ssh|scp|sftp|rsh|rsync):hosts' hosts 'reply=(${=${${(f)"$(cat {/etc/ssh_,~/.ssh/config,~/.ssh/known_}hosts(|2)(N) /dev/null)"}%%[# ]*}//,/ })'

