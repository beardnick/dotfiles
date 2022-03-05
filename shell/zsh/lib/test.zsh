#!/usr/bin/env zsh

source "$HOME/.config/zsh/lib/log.zsh"

assertNotNull(){
    if [[ -z "$1" ]]; then
        error "expect not null"
        # exit会直接把zsh进程关闭,而不是退出函数
        exit 1
    fi
}


assertNull(){
    if [[ ! -z "$1" ]]; then
        error "expect null, get $1"
        exit 1
    fi
}


assertSucced(){
    if [[ "$?" != 0 ]]; then
        error "failed"
        exit 1
    fi
}
