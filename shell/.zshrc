
zmodload zsh/zprof


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
   zdharma-continuum/z-a-patch-dl \
   zdharma-continuum/z-a-as-monitor \
   zdharma-continuum/z-a-bin-gem-node

# history

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=5000000
SAVEHIST=$HISTSIZE
setopt SHARE_HISTORY


# key binding

## use emacs mode
bindkey -e

## use $EDITOR to edit command
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# 在输入的指令是路径时自动进入
setopt autocd

#zinit light Aloxaf/fzf-tab

# Two regular plugins loaded without tracking.
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit light skywind3000/z.lua
zinit light xvoland/Extract

#zinit light RobSis/zsh-completion-generator
#zinit light hlissner/zsh-autopair
zinit light chrissicool/zsh-256color
zinit light Tarrasch/zsh-bd
#zinit light zpm-zsh/ls

zinit light zdharma-continuum/fast-syntax-highlighting

# git
zinit snippet OMZP::git

CONFIG="$HOME/.config/zsh"
LOCAL_CONFIG="$HOME/.config/local/config_zsh.zsh"

#lib 

for f in $(find "$CONFIG/lib" -name "*.zsh"); do
    source "$f"
done

# colors

load_all "$CONFIG/color"

# alias

source "$CONFIG/alias.zsh"

# env

source "$CONFIG/env.zsh"

# core config
load_all "$CONFIG/core"

# rvm

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
vim() { (unset GEM_PATH GEM_HOME; command vim "$@") }

# cheat

export CHEAT_EDITOR="nvim -u $HOME/vimlite.vim -N"

# encode

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

setopt append_history

[[ -f "$LOCAL_CONFIG" ]] && source "$LOCAL_CONFIG"

add_path "$HOME/.local/bin"


