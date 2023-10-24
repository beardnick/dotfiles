#!/usr/bin/env zsh

countdown() {
    hide_cursor
    number=$1
    for (( i = 0; i < $number; i++ )) {
        print  -P "%B%F{red}"  $((number - i))
        sleep 1
        clear_lastLine
    }
    show_cursor
}

error(){
    print -P "%B%F{red}" $@
}

warning(){
    print -P "%B%F{yellow}" $@
}

info(){
    print -P "%B%F{green}" $@
}
