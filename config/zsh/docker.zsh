#!/usr/bin/env bash
#
# podman helper functions/aliases to make it more easyer
# to work with our containers.
#
command -v podman >/dev/null 2>&1 && {

alias pd=podman

# Get latest container ID
alias dl="podman ps -l -q"
# Get process included stop container
alias dpa="podman ps -a"
# Get images
alias di="podman images"
# Get container IP
alias dip="podman inspect --format '{{ .NetworkSettings.IPAddress }}'"
# Run deamonized container, e.g., $dkd base /bin/echo hello
alias dkd="podman run -d -P"
# Run interactive container, e.g., $dki base /bin/bash
alias dki="podman run -i -t -P"
# Execute interactive container, e.g., $dex base /bin/bash
alias dex="podman exec -i -t"
# Stop and Remove all containers
alias drmf='podman stop $(podman ps -a -q) && podman rm $(podman ps -a -q)'
# Attach to latest container ID
alias dexl='podman exec -it $(podman ps -l -q) /bin/bash'

# Launch ctf podman
alias pdhere='podman run --cap-add=SYS_PTRACE -it -d --rm -v ~/.Xauthority:/root/.Xauthority --net=host -v "${PWD}:/ctf" ctfv2'

function _list_images_names
{
    echo $(podman images|sed -e '/REPOSITORY/d'|awk '{print $1}')
}

# Stop all containers
function dstopa
{
    podman stop $(podman ps -a -q)
}

# Stop a podman service
function dstop
{
    podman stop $1
}

function drmi
{
    podman rmi $1
}
compdef '_arguments "1: :($(_list_images_names))"' drmi
# compdef _podman_img_list drmi

# Remove all containers
function drma
{
    podman rm $(podman ps -a -q)
}

# Remove all images
function driall
{
    read -p "Are you sure you want to delete all podman images ? "
    podman rmi $(podman images -q)
}

function podman-clean
{
  podman rmi -f $(podman images -q -a -f dangling=true)
}

# Update all podman images
# and delete none
function diu
{
    podman images | awk '{print $1}' | while read line; do podman pull $line; done
    if podman images | grep -q "<none>" ; then
        delnone
    fi
}


function drun
{
    podman run -it --rm $@
}
compdef '_arguments "1: :($(_list_images_names))"' drun


} # end check podman command
