# ZSH
#export ZSH=$HOME/.oh-my-zsh
#source $ZSH/oh-my-zsh.sh

# Antigen: https://github.com/zsh-users/antigen
ANTIGEN="$HOME/.local/bin/antigen.zsh"

# Install antigen.zsh if not exist
if [ ! -f "$ANTIGEN" ]; then
	echo "Installing antigen ..."
	[ ! -d "$HOME/.local" ] && mkdir -p "$HOME/.local" 2> /dev/null
	[ ! -d "$HOME/.local/bin" ] && mkdir -p "$HOME/.local/bin" 2> /dev/null
	[ ! -f "$HOME/.z" ] && touch "$HOME/.z"
	URL="http://git.io/antigen"
	TMPFILE="/tmp/antigen.zsh"
	if [ -x "$(which curl)" ]; then
		curl -L "$URL" -o "$TMPFILE" 
	elif [ -x "$(which wget)" ]; then
		wget "$URL" -O "$TMPFILE" 
	else
		echo "ERROR: please install curl or wget before installation !!"
		exit
	fi
	if [ ! $? -eq 0 ]; then
		echo ""
		echo "ERROR: downloading antigen.zsh ($URL) failed !!"
		exit
	fi;
	echo "move $TMPFILE to $ANTIGEN"
	mv "$TMPFILE" "$ANTIGEN"
fi


# Initialize command prompt
export PS1="%n@%m:%~%# "

# Enable 256 color to make auto-suggestions look nice
export TERM="xterm-256color"


# Load local bash/zsh compatible settings
_INIT_SH_NOFUN=1
[ -f "$HOME/.local/etc/init.sh" ] && source "$HOME/.local/etc/init.sh"

# exit for non-interactive shell
[[ $- != *i* ]] && return

# WSL (aka Bash for Windows) doesn't work well with BG_NICE
[ -d "/mnt/c" ] && [[ "$(uname -a)" == *Microsoft* ]] && unsetopt BG_NICE


# Initialize antigen
source "$ANTIGEN"

# themes
# antigen theme denysdovhan/spaceship-prompt
#




# Initialize oh-my-zsh
antigen use oh-my-zsh

# default bundles
# visit https://github.com/unixorn/awesome-zsh-plugins
# antigen bundle git
# antigen bundle heroku
antigen bundle pip
antigen bundle svn-fast-info
# antigen bundle command-not-find

antigen bundle colorize
antigen bundle github
antigen bundle python
antigen bundle rupa/z z.sh
# antigen bundle z

antigen bundle zsh-users/zsh-autosuggestions
antigen bundle zsh-users/zsh-completions
# antigen bundle supercrabtree/k
antigen bundle Vifon/deer

antigen bundle willghatch/zsh-cdr
# antigen bundle zsh-users/zaw

# uncomment the line below to enable theme
# antigen theme ys

# use wakatime
# antigen bundle sobolevn/wakatime-zsh-plugin

antigen bundle extract


# check login shell
if [[ -o login ]]; then
	[ -f "$HOME/.local/etc/login.sh" ] && source "$HOME/.local/etc/login.sh"
	[ -f "$HOME/.local/etc/login.zsh" ] && source "$HOME/.local/etc/login.zsh"
fi

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

# load local config
[ -f "$HOME/.local/etc/config.zsh" ] && source "$HOME/.local/etc/config.zsh" 
[ -f "$HOME/.local/etc/local.zsh" ] && source "$HOME/.local/etc/local.zsh"


# enable syntax highlighting
antigen bundle zsh-users/zsh-syntax-highlighting


antigen apply

# zsh template #################################################################

# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$HOME/.npm-global/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https:// github.com/robbyrussell/oh-my-zsh/wiki/Themes
ZSH_THEME="ys"

#autoload -U promptinit; promptinit
#prompt pure

# autoload -U promptinit; promptinit
# prompt pure
# Set list of themes to load
# Setting this variable when ZSH_THEME=random
# cause zsh load theme from this variable instead of
# looking in ~/.oh-my-zsh/themes/
# An empty array have no effect
# ZSH_THEME_RANDOM_CANDIDATES=( "robbyrussell" "agnoster" )

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# You can set one of the optional three formats:
# "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# or set a custom format using the strftime function format specifications,
# see 'man strftime' for details.
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
  git
  # autojump
  #fbterm
  pip
  python
  sudo
  pylint
  # you-should-use $plugins
  # geeknote
)

source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# zsh template ################################################################


# setup for deer
autoload -U deer
zle -N deer

# default keymap
bindkey -s '\ee' 'vim\n'
bindkey '\eh' backward-char
bindkey '\el' forward-char
bindkey '\ej' down-line-or-history
bindkey '\ek' up-line-or-history
# bindkey '\eu' undo
bindkey '\eH' backward-word
bindkey '\eL' forward-word
bindkey '\eJ' beginning-of-line
bindkey '\eK' end-of-line

bindkey -s '\eo' 'cd ..\n'
bindkey -s '\e;' 'll\n'

bindkey '\e[1;3D' backward-word
bindkey '\e[1;3C' forward-word
bindkey '\e[1;3A' beginning-of-line
bindkey '\e[1;3B' end-of-line

bindkey '\e' deer
#bindkey 'tab' autosuggest-accept


alias v="vim -u NONE -N"
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
alias conf="vim ~/.zshrc"
alias name="find . -name"
#alias cunzip='cunzip.sh'
alias cunzip='unzip -O cp936'
# alias open='xdg-open'
#alias open='open.sh'
alias ll='ls -al'
alias cls='clear'
alias tencent='ssh ubuntu@123.207.19.172'
#alias cheat='~/.local/bin/cheat'
#alias chee='cheat -e'
alias pip3='python3 -m pip'
alias cheat='~/study/shell/useful-scripts/my_cheat.sh'
alias python='python3'
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
#alias nvim="~/download/nvim.appimage"
#eval $(thefuck --alias)
#alias rexxnet="sudo killall miredo && sudo miredo"
#alias spring='mt -g "spring|jvm|js|java|mybatis|vue|nginx"'
alias spring='~/ubuntu-data/software/spring-2.0.1.RELEASE/bin/spring'
alias tf='mt -g "tf|py|cc"'
alias tool='mt -g "tool|shell|git|vim|iptables|sed|awk|gcc|gdb|idea"'
alias intv='mt -g "intv|leetcode|os|net|db|mysql"'
alias my='cheat my'
alias task='cheat task'
alias study='cheat study'
alias vscode='code'
alias remote='~/ubuntu-data/software/ngrok tcp 22 2> ~/logs/ngrok.log >&1  &'
alias ngrok='~/ubuntu-data/software/ngrok'
alias wiz='~/ubuntu-data/software/WizNote-2.5.9-x86_64.AppImage &> ~/logs/wiz.log &'
alias mtm='mt -m'
alias mtc='mt -c'
alias mts='mt -s'
alias mtg='mt -g'
alias mtp='mt -p'
alias mtd='mt -d'
alias rmtm='rmt -m'
alias rmtc='rmt -c'
alias rmts='rmt -s'
alias rmtg='rmt -g'
alias rmtp='rmt -p'
alias rmtd='rmt -d'
#alias feige='~/ubuntu-data/software/feige.sh &>~/logs/feige.log &'
alias emacs='emacs25 -nw'
alias tb='python /usr/local/lib/python3.5/dist-packages/tensorboard/main.py'
alias sicong='ssh root@39.108.154.79'
alias ali='ssh admin@39.108.248.254'
alias sun='~/ubuntu-data/software/sunloginclient/run.sh'
alias rm='trash'
alias mr='restore-trash'
alias cat='bat'
alias edex='~/download/eDEX-UI.Linux.x86_64.AppImage'
alias op='~/study/shell/tool/idea_operation.sh'
alias search='~/study/shell/tool/search_tool.sh'
alias pick='~/study/shell/tool/pick.sh'

export TEN="123.207.19.172"
export SICONG="39.108.154.79"


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

# source function.sh if it exists
[ -f "$HOME/.local/etc/function.sh" ] && . "$HOME/.local/etc/function.sh"


# ignore complition
zstyle ':completion:*:complete:-command-:*:*' ignored-patterns '*.pdf|*.exe|*.dll'
zstyle ':completion:*:*sh:*:' tag-order files

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
export PATH="$PATH:$HOME/.rvm/bin"
LD_LIBRARY_PATH=$LD_LIBRARY_PATH:~/.rvm/rubies/ruby-2.3.7/lib/
export LD_LIBRARY_PATH
vim() { (unset GEM_PATH GEM_HOME; command vim "$@") }
export CHEAT_EDITOR=vim

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
#tmux

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# date to mark file
datetag=$(date +"%Y-%m-%d")

if [ "$TERM" = "linux" ]; then
    fbterm byobu
fi

csk="程时坤2016317200302"
#/home/qianz/study/course/embed/opt/FriendlyARM/toolschain/4.5.1/bin
PATH=$PATH:.local/bin:/home/beardnick/study/shell/tool/:/home/qianz/study/course/embed/opt/FriendlyARM/toolschain/4.5.1/bin
export PATH

alias clion='/home/beardnick/Downloads/Compressed/clion-2018.2.4/bin/clion.sh'
#alias image='sudo docker run -ti ubuntu bash'

alias tgo='tmux attach -t'
alias tl='tmux ls'
alias findall='grep -rnP'
alias summary='~/study/shell/useful-script/summary_tool.sh'
alias quiz='~/study/shell/useful-scripts/quiz.sh'

export EDITOR=vim
export PATH="~/.cabal:$PATH"

export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles

export http_proxy="http://127.0.0.1:12639"
export https_proxy="http://127.0.0.1:12639"

export GOPATH=/Users/mac/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOBIN
