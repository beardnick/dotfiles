#!/usr/bin/env zsh


# Easier navigation: .., ..., ...., ....., ~ and -
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ~="cd ~" # `cd` is probably faster to type though
alias -- -="cd -"

# Detect which `ls` flavor is in use
if ls --color > /dev/null 2>&1; then # GNU `ls`
	colorflag="--color"
	export LS_COLORS='no=00:fi=00:di=01;31:ln=01;36:pi=40;33:so=01;35:do=01;35:bd=40;33;01:cd=40;33;01:or=40;31;01:ex=01;32:*.tar=01;31:*.tgz=01;31:*.arj=01;31:*.taz=01;31:*.lzh=01;31:*.zip=01;31:*.z=01;31:*.Z=01;31:*.gz=01;31:*.bz2=01;31:*.deb=01;31:*.rpm=01;31:*.jar=01;31:*.jpg=01;35:*.jpeg=01;35:*.gif=01;35:*.bmp=01;35:*.pbm=01;35:*.pgm=01;35:*.ppm=01;35:*.tga=01;35:*.xbm=01;35:*.xpm=01;35:*.tif=01;35:*.tiff=01;35:*.png=01;35:*.mov=01;35:*.mpg=01;35:*.mpeg=01;35:*.avi=01;35:*.fli=01;35:*.gl=01;35:*.dl=01;35:*.xcf=01;35:*.xwd=01;35:*.ogg=01;35:*.mp3=01;35:*.wav=01;35:'
else # macOS `ls`
	colorflag="-G"
	export LSCOLORS='BxBxhxDxfxhxhxhxhxcxcx'
fi

# List all files colorized in long format
alias l="ls -lF ${colorflag}"

# List all files colorized in long format, excluding . and ..
alias la="ls -lAF ${colorflag}"

# List only directories
alias lsd="ls -lF ${colorflag} | grep --color=never '^d'"

# Always use color output for `ls`
alias ls="command ls ${colorflag}"

# Always enable colored `grep` output
# Note: `GREP_OPTIONS="--color=auto"` is deprecated, hence the alias usage.
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias x='extract'


#alias copy='~/study/shell/useful-scripts/copy.sh'
alias typora='/Applications/Typora.app/Contents/MacOS/Typora'
alias fopen='fzf | xargs open'
alias redis-cli='redis-cli --raw'
alias reload="source ~/.zshrc"
# alias sed="gsed"
alias run="osascript"
alias v="nvim -u ~/.vimlite.vim -N"
alias code="/Applications/Visual\ Studio\ Code.app/Contents/Resources/app/bin/code"
alias cman="man -M /usr/share/man/zh_CN"
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
alias la="ls -a"
alias pad="xinput set-prop 11 \"Device Enabled\" 1 "
alias xpad="xinput set-prop 11 \"Device Enabled\" 0"
#alias tim="~/download/TIM-x86_64.AppImage"
#alias tim="~/ubuntu-data/software/TIM-x86_64.AppImage > /dev/null 2>&1 &"
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
alias sicong='ssh root@39.108.154.79'
alias ali='ssh admin@39.108.248.254'
alias rm='trash'
alias mr='trash-restore'
alias cat='bat'
# alias pick='~/study/shell/tool/pick.sh'
alias tree='tree -N'
alias pwdc='pwd | pbcopy'


alias spacevim="rm ~/.config/nvim; ln -s ~/.SpaceVim ~/.config/nvim"
alias myvim="rm ~/.config/nvim;ln -s ~/my.nvim ~/.config/nvim"
alias thinkvim="rm ~/.config/nvim;ln -s ~/ThinkVim ~/.config/nvim"
alias debugvim="rm ~/.config/nvim;ln -s ~/debug.nvim ~/.config/nvim"
alias gd='git icdiff'

