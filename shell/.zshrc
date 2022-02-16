
zmodload zsh/zprof


### Added by zi's installer
if [[ ! -f $HOME/.zi/bin/zi.zsh ]]; then
    print -P "%F{33}▓▒░ %F{220}Installing DHARMA Initiative Plugin Manager (zdharma/zi)…%f"
    command mkdir -p "$HOME/.zi" && command chmod g-rwX "$HOME/.zi"
    command git clone https://github.com/zdharma/zi "$HOME/.zi/bin" && \
        print -P "%F{33}▓▒░ %F{34}Installation successful.%f%b" || \
        print -P "%F{160}▓▒░ The clone has failed.%f%b"
fi

source "$HOME/.zi/bin/zi.zsh"
autoload -Uz _zi
(( ${+_comps} )) && _comps[zi]=_zi


# Load a few important annexes, without Turbo
# (this is currently required for annexes)
zi light-mode for \
    zi-zsh/z-a-patch-dl \
    zi-zsh/z-a-as-monitor \
    zi-zsh/z-a-bin-gem-node

### End of zi's installer chunk


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

#zi light Aloxaf/fzf-tab


# Two regular plugins loaded without tracking.
zi light zsh-users/zsh-completions
zi light zsh-users/zsh-autosuggestions
# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

# Load the pure theme, with zsh-async library that's bundled with it.
# zi ice pick"async.zsh" src"pure.zsh"
# zi light sindresorhus/pure

zi light skywind3000/z.lua
zi light xvoland/Extract

#zi light RobSis/zsh-completion-generator
zi light hlissner/zsh-autopair
zi light chrissicool/zsh-256color
zi light Tarrasch/zsh-bd
#zi light zpm-zsh/ls

zi light zdharma/fast-syntax-highlighting


# git
zi snippet OMZP::git


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
vim() { (unset GEM_PATH GEM_HOME; command vim "$@") }

# cheat

export CHEAT_EDITOR="nvim -u $HOME/vimlite.vim -N"

# encode

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export EDITOR="nvim -u $HOME/.vimlite.vim -N"



# export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
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

setopt append_history

add_path "$HOME/application"

# Use powerline
USE_POWERLINE="true"
# Source manjaro-zsh-configuration
if [[ -e /usr/share/zsh/manjaro-zsh-config ]]; then
  source /usr/share/zsh/manjaro-zsh-config
fi
# Use manjaro zsh prompt
if [[ -e /usr/share/zsh/manjaro-zsh-prompt ]]; then
  source /usr/share/zsh/manjaro-zsh-prompt
fi
