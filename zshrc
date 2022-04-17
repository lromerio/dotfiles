# If you come from bash you might have to change your $PATH.
export PATH=$HOME/.local/bin:$HOME/go/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH="/home/lucio/.oh-my-zsh"
# export XDG_CONFIG_HOME="home/lucio/.config/"

# Which plugins would you like to load?
# Standard plugins can be found in ~/.oh-my-zsh/plugins/*
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    sudo
    vi-mode
)

# vi-mode
#VI_MODE_SET_CURSOR=true

source $ZSH/oh-my-zsh.sh
#source /home/lucio/.zsh/promptline.zsh

# powerline
powerline-daemon -q
. /usr/share/powerline/bindings/zsh/powerline.zsh

#ZSH_THEME="gruvbox"
SOLARIZED_THEME="dark"

# User configuration

HISTFILE="$HOME/.zhistory"
HISTSIZE=10000
SAVEHIST=10000

compinit -d ~/.cache/zsh/zcompdump-$ZSH_VERSION

# History
# setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
# setopt HIST_BEEP                 # Beep when accessing nonexistent history.
# setopt BANG_HIST                 # Treat the '!' character specially during expansion.
# setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
# setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
# setopt SHARE_HISTORY             # Share history between all sessions.
# setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
# setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS        # Delete old recorded entry if new entry is a duplicate.
# setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE           # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS           # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS          # Remove superfluous blanks before recording entry.

# Source plugins from oh-my-zsh and custom (precedence to custom
zsh_plugins=(
    ## custom
    aliases
    directories
    docker
    ssh
)
ZSH_FULL_PLUGIN_PATHS=(
    "${HOME}/.config/zsh/plugins/"
    "${HOME}/.config/zsh/"
)
for PLUGIN_PATH in $ZSH_FULL_PLUGIN_PATHS; do
    for PLUGIN in ${zsh_plugins}; do
        [ -f "${PLUGIN_PATH%/}/${PLUGIN}.zsh" ] && source "${PLUGIN_PATH%/}/${PLUGIN}.zsh" &>/dev/null
    done
done


export LANG=en_US.UTF-8
export EDITOR='nvim'
export VIEW='vim'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=229"

source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh

#bindkey "^[[3~" delete-char
