#!/usr/bin/env zsh

mac=(
    "$HOME/.SpaceVim/bin"
    "$HOME/.cabel"
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
    "$HOME/bin"
    "$HOME/dotfiles/scripts"
    "$HOME/study/shell/useful-scripts"
    "/opt/metasploit-framework/bin"
    "/usr/local/bin"
    "/usr/local/opt/llvm/bin"
    "/usr/local/opt/mysql@5.7/bin"
    "/usr/local/opt/ruby/bin"
    "/usr/local/opt/node@10/bin"
    ) 

linux=() 
windows=() 


exports=()

case $(uname) in
    "Darwin" )
       exports=($mac)
       ;;
    "linux")
       exports=$linux
       ;;
   "windows")
       exports=$windows
       ;;
esac

for e ($exports){
    add_path "$e"
}

