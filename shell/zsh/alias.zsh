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

alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

alias x='extract'


alias fopen='fzf | xargs open'
alias redis-cli='redis-cli --raw'
alias reload="source ~/.zshrc"
# alias sed="gsed"
alias run="osascript"
alias v="nvim -u ~/.vimlite.vim -N"
alias cman="man -M /usr/share/man/zh_CN"
alias xclip="xclip -selection c"
alias less="bat"
alias conf="v ~/.zshrc"
alias name="find . -name"
alias cunzip='unzip -O cp936'
alias ll='ls -al'
alias cls='clear'
alias la="ls -a"
alias pad="xinput set-prop 11 \"Device Enabled\" 1 "
alias xpad="xinput set-prop 11 \"Device Enabled\" 0"
alias sync="sync & mt -i \">\" "
alias vscode='code'
alias rm='trash'
alias mr='trash-restore'
alias cat='bat'
alias tree='tree -N'
alias pwdc='pwd | pbcopy'

alias gd='git icdiff'

