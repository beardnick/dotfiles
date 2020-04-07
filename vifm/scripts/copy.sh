#!/usr/bin/env bash

# copy file or directory to system clipboard

if [[ -z "$1" ]]; then
    exit 1
fi

# get file absolute path
file=$(realpath  "$1")

#echo $file

osascript -e "tell app \"Finder\" to set the clipboard to ( POSIX file \"$file\" )"
