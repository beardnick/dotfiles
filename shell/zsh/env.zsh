#!/usr/bin/env zsh

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

