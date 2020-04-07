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

# Two regular plugins loaded without tracking.
#zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
#zinit load zdharma/history-search-multi-word

# Load the pure theme, with zsh-async library that's bundled with it.
zinit ice pick"async.zsh" src"pure.zsh"
zinit light sindresorhus/pure

zinit light skywind3000/z.lua
zinit light xvoland/Extract
#zinit snippet OMZ::plugins/gitignore/gitignore.plugin.zsh

#zinit light RobSis/zsh-completion-generator
#zinit light hlissner/zsh-autopair
zinit light chrissicool/zsh-256color
zinit light Tarrasch/zsh-bd
#zinit light zpm-zsh/ls

zinit light Aloxaf/fzf-tab

ZSH=$HOME/.oh-my-zsh

if [[ ! -d $ZSH ]]; then
    git clone https://github.com/ohmyzsh/ohmyzsh.git $ZSH
fi

plugins=(
  git
  gitfast
  #fbterm
  python
  sudo
  #extact
  # brew
  # geeknote
  gitignore
  #vi-mode
)


# 需要ohmyzsh才能让fzf可以显示更多的历史命令
source $ZSH/oh-my-zsh.sh
# 使用手动装没有bug
#zinit load ohmyzsh/ohmyzsh

zinit light zdharma/fast-syntax-highlighting

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"

# syntax color definition
ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
typeset -A ZSH_HIGHLIGHT_STYLES
# ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
# ZSH_HIGHLIGHT_STYLES[alias]='fg=magenta,bold'
ZSH_HIGHLIGHT_STYLES[default]=none
ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=009
ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=009,standout
ZSH_HIGHLIGHT_STYLES[alias]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[builtin]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[function]=fg=cyan,bold
ZSH_HIGHLIGHT_STYLES[command]=fg=white,bold
ZSH_HIGHLIGHT_STYLES[precommand]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[commandseparator]=none
ZSH_HIGHLIGHT_STYLES[hashed-command]=fg=009
ZSH_HIGHLIGHT_STYLES[path]=fg=214,underline
ZSH_HIGHLIGHT_STYLES[globbing]=fg=063
ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=white,underline
ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=none
ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=063
ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=009
ZSH_HIGHLIGHT_STYLES[assign]=none


# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:$PATH

alias copy='~/study/shell/useful-scripts/copy.sh'
alias typora='/Applications/Typora.app/Contents/MacOS/Typora'
alias fopen='fzf | xargs open'
alias redis-cli='redis-cli --raw'
alias reload="source ~/.zshrc"
# alias sed="gsed"
alias run="osascript"
alias v="nvim -u ~/.vimlite.vim -N"
alias anki="clanki"
alias vless="/usr/local/Cellar/neovim/0.3.8/share/nvim/runtime/macros/less.sh"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias lepton="~/ubuntu-data/software/Lepton\ 1.8.0.AppImage"
alias sunlogin="sudo /usr/local/sunlogin/start.sh"
alias acc="arm-linux-gcc"
alias cman="man -M /usr/share/man/zh_CN"
alias md="python2 ~/study/python/org-to-md.py"
alias gen="~/study/shell/useful-scripts/gen_code.sh"
alias xclip="xclip -selection c"
alias less="bat"
alias conf="v ~/.zshrc"
alias name="find . -name"
#alias cunzip='cunzip.sh'
alias cunzip='unzip -O cp936'
# alias open='xdg-open'
#alias open='open.sh'
alias ll='ls -al'
alias cls='clear'
alias tencent='ssh ubuntu@123.207.19.172'
#alias cheat='~/.local/bin/cheat'
# alias chee='cheat -e'
alias cheat='~/study/shell/useful-scripts/my_cheat.sh'
# alias python='python3'
alias la="ls -a"
alias xxnet="~/ubuntu-data/software/XX-Net-3.12.10/start"
alias pad="xinput set-prop 11 \"Device Enabled\" 1 "
alias xpad="xinput set-prop 11 \"Device Enabled\" 0"
#alias tim="~/download/TIM-x86_64.AppImage"
#alias tim="~/ubuntu-data/software/TIM-x86_64.AppImage > /dev/null 2>&1 &"
alias postman="~/ubuntu-data/software/Postman/app/Postman > /dev/null 2>&1 &"
alias rmt="~/study/shell/tool/remote_mt.sh"
alias mt="~/study/time/mt.py"
alias install="sudo apt-get install"
alias sync="sync & mt -i \">\" "
alias aly="ssh java@47.75.143.54"
alias feidian="ssh java@218.199.68.208"
alias bt="aria2c --enable-rpc --rpc-listen-all; node ~/study/git/webui-aria2/node-server.js"
#alias nvim="cd .;nvim"
#eval $(thefuck --alias)
#alias rexxnet="sudo killall miredo && sudo miredo"
#alias spring='mt -g "spring|jvm|js|java|mybatis|vue|nginx"'
#alias spring='~/ubuntu-data/software/spring-2.0.1.RELEASE/bin/spring'
alias tf='mt -g "tf|py|cc"'
alias tool='mt -g "tool|shell|git|vim|iptables|sed|awk|gcc|gdb|idea"'
alias intv='mt -g "intv|leetcode|os|net|db|mysql"'
alias my='cheat my'
alias task='cheat task'
alias study='cheat study'
alias vscode='code'
# alias remote='~/ngrok tcp 22 2> ~/logs/ngrok.log >&1  &'
# alias ngrok='~/ngrok'
alias wiz='~/ubuntu-data/software/WizNote-2.5.9-x86_64.AppImage &> ~/logs/wiz.log &'
alias mtm='mt -m'
alias mtc='mt -c'
alias mts='mt -s'
alias mtg='mt -g'
alias mtp='mt -p'
alias mtd='mt -d'
#alias feige='~/ubuntu-data/software/feige.sh &>~/logs/feige.log &'
# alias emacs='emacs25 -nw'
alias tb='python /usr/local/lib/python3.5/dist-packages/tensorboard/main.py'
alias sicong='ssh root@39.108.154.79'
alias ali='ssh admin@39.108.248.254'
alias sun='~/ubuntu-data/software/sunloginclient/run.sh'
alias rm='trash'
alias mr='trash-restore'
alias cat='bat'
alias edex='~/download/eDEX-UI.Linux.x86_64.AppImage'
alias op='~/study/shell/tool/idea_operation.sh'
alias search='~/study/shell/tool/search_tool.sh'
# alias pick='~/study/shell/tool/pick.sh'
alias tree='tree -N'
alias pwdc='pwd | pbcopy'
export TEN="123.207.19.172"

# options
unsetopt correct_all
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
setopt HIST_VERIFY # Don't execute immediately upon history expansion.

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.rvm/rubies/ruby-2.3.7/lib/
export LD_LIBRARY_PATH
vim() { (unset GEM_PATH GEM_HOME; command vim "$@") }
export CHEAT_EDITOR="nvim -u ~/.vimlite.vim -N"

#-------------------------
#|makes man page colorful|
#-------------------------
export LESS_TERMCAP_mb=$'\E[1m\E[32m'
export LESS_TERMCAP_mh=$'\E[2m'
export LESS_TERMCAP_mr=$'\E[7m'
export LESS_TERMCAP_md=$'\E[1m\E[36m'
export LESS_TERMCAP_ZW=""
export LESS_TERMCAP_us=$'\E[4m\E[1m\E[37m'
export LESS_TERMCAP_me=$'\E(B\E[m'
export LESS_TERMCAP_ue=$'\E[24m\E(B\E[m'
export LESS_TERMCAP_ZO=""
export LESS_TERMCAP_ZN=""
export LESS_TERMCAP_se=$'\E[27m\E(B\E[m'
export LESS_TERMCAP_ZV=""
export LESS_TERMCAP_so=$'\E[1m\E[33m\E[44m'


export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# date to mark file
datetag=$(date +"%Y-%m-%d")

#/home/qianz/study/course/embed/opt/FriendlyARM/toolschain/4.5.1/bin
PATH=$PATH:.local/bin:/home/beardnick/study/shell/tool/:/home/qianz/study/course/embed/opt/FriendlyARM/toolschain/4.5.1/bin
export PATH

#alias image='sudo docker run -ti ubuntu bash'

#alias tgo="tmux attach -t \$(tmux ls | awk -F \":\" '{print \$1}' | fzf)"
# alias tl='tmux ls'
alias findall='grep -rnP'
alias summary='~/study/shell/useful-script/summary_tool.sh'
alias quiz='~/study/shell/useful-scripts/quiz.sh'

export EDITOR="nvim -u ~/.vimlite.vim -N"
export PATH="~/.cabal:$PATH"

# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# export http_proxy="http://127.0.0.1:12639"
# export https_proxy="http://127.0.0.1:12639"

export GOPATH=/Users/mac/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN

export PATH=$PATH:/Users/mac/study/shell/useful-scripts

export HOMEBREW_NO_AUTO_UPDATE=true
export PATH=$PATH:$HOME/.SpaceVim/bin


JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_221.jdk/Contents/Home
PATH=$JAVA_HOME/bin:$PATH:.
CLASSPATH=$JAVA_HOME/lib/tools.jar:$JAVA_HOME/lib/dt.jar:.
export JAVA_HOME
export PATH
export CLASSPATH
export PATH="/usr/local/opt/node@10/bin:$PATH"
export LDFLAGS="-L/usr/local/opt/node@10/lib"
export CPPFLAGS="-I/usr/local/opt/node@10/include"


# source /usr/local/opt/autoenv/activate.sh

PATH=/Users/mac/opt/anaconda3/bin:$PATH

# export PATH=/usr/local/opt/coreutils/libexec/gnubin:$PATH
export GO111MODULE=on # manually active module mode
export NAVI_PATH="/Users/mac/dotfiles/navi"
export FZF_DEFAULT_OPTS="--height 50% --layout=reverse --preview '(highlight -O ansi {} || bat {}) 2> /dev/null | head -500'"
# export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview 'bat {}'"
# export FZF_DEFAULT_OPTS="--height 40% --layout=reverse --preview '(bat {}) 2> /dev/null | head -500'"

fman() {
    man -k . | fzf --prompt='Man> ' | awk '{print $1}' | gsed 's/(.*)//g' | xargs man
}

sed(){
    if [[ "$(uname)" == "Darwin" ]]; then
        if [[ -x "$(which gsed)" ]]; then
            command gsed "$@"
        else
            echo "WARNING: sed in mac is different from it in linux,please install gsed"
            command sed "$@"
        fi
    else
        command sed "$@"
    fi
}

open(){
    if [[ "$(uname)" == "Darwin" ]]; then
        command open "$@"
    else
        command xdg-open "$@"
    fi
}

alias spacevim="rm ~/.config/nvim; ln -s ~/.SpaceVim ~/.config/nvim"
alias myvim="rm ~/.config/nvim;ln -s ~/my.nvim ~/.config/nvim"
alias thinkvim="rm ~/.config/nvim;ln -s ~/ThinkVim ~/.config/nvim"
alias debugvim="rm ~/.config/nvim;ln -s ~/debug.nvim ~/.config/nvim"
alias gd='git icdiff'


FZF_DEFAULT_COMMAND='ag --hidden --ignore .git -l -g ""'
export PATH="/usr/local/opt/llvm/bin:$PATH"

export VIFM="/Users/mac/.config/vifm"
export PATH="/usr/local/opt/mysql@5.7/bin:$PATH"
export PATH="$PATH:$HOME/dotfiles/scripts"
#export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

# >>> conda initialize >>>
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


# export http_proxy=http://127.0.0.1:1087;export https_proxy=http://127.0.0.1:1087;


#!/bin/bash

# Retries a command on failure.
# $1 - the max number of attempts
# $2... - the command to run

retry() {
    local -r -i max_attempts="$1"; shift
    local -r cmd="$@"
    local -i attempt_num=1
    until $cmd
    do
        if ((attempt_num==max_attempts))
        then
            echo "Attempt $attempt_num failed and there are no more attempts left!"
            return 1
        else
            echo "Attempt $attempt_num failed! Trying again in $attempt_num seconds..."
            sleep $((attempt_num++))
        fi
    done
}

export PATH="/usr/local/opt/ruby/bin:$HOME/.local/bin:$PATH"
#set -o vi

# 启用fzf的一些key binding和小组件
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

_call_navi() {
   local -r buff="$BUFFER"
   local -r r="$(printf "$(navi --print </dev/tty)")"
   zle kill-whole-line
   zle -U "${buff}${r}"
}

zle -N _call_navi

bindkey '^g' _call_navi


