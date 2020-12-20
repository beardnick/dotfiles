#!/usr/bin/env zsh

clear_lastLine() {
        tput cuu 1 && tput el
}

hide_cursor() {
    tput civis
}

show_cursor() {
    tput cnorm
}
