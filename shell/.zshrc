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

# 启用fzf的一些key binding和小组件
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

#zinit light Aloxaf/fzf-tab

# Two regular plugins loaded without tracking.
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
#zinit load zdharma/history-search-multi-word



# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit light skywind3000/z.lua
zinit light xvoland/Extract
#zinit snippet OMZ::plugins/gitignore/gitignore.plugin.zsh

zinit light RobSis/zsh-completion-generator
#zinit light hlissner/zsh-autopair
zinit light chrissicool/zsh-256color
zinit light Tarrasch/zsh-bd
#zinit light zpm-zsh/ls

zinit light zdharma/fast-syntax-highlighting

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

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

export GOPATH=/Users/mac/go
export GOBIN=$GOPATH/bin
add_path "$GOBIN"
export GOPROXY=https://mirrors.aliyun.com/goproxy/

# brew

export HOMEBREW_NO_AUTO_UPDATE=true

# java

export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
export CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
add_path "$JAVA_HOME/bin:."
export LDFLAGS="-L/usr/local/opt/node@10/lib"
export CPPFLAGS="-I/usr/local/opt/node@10/include"


# export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export GO111MODULE=off # manually active module mode
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --preview '(highlight -O ansi {} || bat {}) 2> /dev/null | head -500'"

FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'

export VIFM="/Users/mac/.config/vifm"

# conda

add_path "$HOME/opt/anaconda3/bin"

# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/Users/mac/opt/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/Users/mac/opt/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/Users/mac/opt/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/Users/mac/opt/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup


# <<< conda initialize <<<

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
