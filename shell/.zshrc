
zmodload zsh/zprof


### Added by Zinit's installer
if [[ ! -f $HOME/.zinit/bin/zinit.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zinit)…%f"
    command mkdir -p "$HOME/.zinit" && command chmod g-rwX "$HOME/.zinit"
    command git clone https://github.com/zdharma/zinit "$HOME/.zinit/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zinit/bin/zinit.zsh"
autoload -Uz _zinit
(( ${+_comps} )) && _comps[zinit]=_zinit


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zinit light-mode for \
    zinit-zsh/z-a-patch-dl \
    zinit-zsh/z-a-as-monitor \
    zinit-zsh/z-a-bin-gem-node

### End of Zinit's installer chunk


# history

[ -z "$HISTFILE" ] && HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=10000


# key binding

## use emacs mode
bindkey -e

## use $EDITOR to edit command
autoload -z edit-command-line
zle -N edit-command-line
bindkey "^X^E" edit-command-line

# 在输入的指令是路径时自动进入
setopt autocd

# 启用fzf的一些key binding和小组件
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
zinit light hlissner/zsh-autopair
zinit light chrissicool/zsh-256color
zinit light Tarrasch/zsh-bd
#zinit light zpm-zsh/ls

zinit light zdharma/fast-syntax-highlighting


# git
zinit snippet OMZP::git


CONFIG="$HOME/.config/zsh"

# functions

for f in $(find "$CONFIG/functions" -name "*.zsh"); do
    source "$f"
done

# colors

load_all "$CONFIG/color"

# alias

source "$CONFIG/alias.zsh"

# env

source "$CONFIG/env.zsh"

# rvm

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
add_path "/$HOME/.rvm/bin"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.rvm/rubies/ruby-2.3.7/lib/
export LD_LIBRARY_PATH
vim() { (unset GEM_PATH GEM_HOME; command vim "$@") }

# cheat

export CHEAT_EDITOR="nvim -u $HOME/vimlite.vim -N"

# encode

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR="nvim -u ~/.vimlite.vim -N"

# golang

#export GOPATH=$HOME/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
add_path "$GOBIN"
export GO111MODULE=auto

# brew

export HOMEBREW_NO_AUTO_UPDATE=true

# java

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
add_path "$JAVA_HOME/bin:."
export LDFLAGS="-L/usr/local/opt/node@10/lib"
export CPPFLAGS="-I/usr/local/opt/node@10/include"


# export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export GO111MODULE=on # manually active module mode
export FZF_DEFAULT_OPTS="--height 80% --layout=reverse --preview '(bat --color=always {}) 2> /dev/null | head -500'"

# FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git --exclude vendor'

#export VIFM="$HOME/.config/vifm"

# navi

export NAVI_PATH="$HOME/dotfiles/navi"

_call_navi() {
   local -r buff="$BUFFER"
   local -r r="$(printf "$(navi --print </dev/tty)")"
   zle kill-whole-line
   zle -U "${buff}${r}"
}

zle -N _call_navi

bindkey '^g' _call_navi

export BAT_CONFIG_PATH="$HOME/.config/.batrc"

export PATH=${PATH}:/usr/local/mysql/bin

test -e "${HOME}/.iterm2_shell_integration.zsh" && source "${HOME}/.iterm2_shell_integration.zsh"

