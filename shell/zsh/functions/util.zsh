#!/usr/bin/env zsh

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

proxy(){
   export http_proxy=http://127.0.0.1:"$1"
   export https_proxy=http://127.0.0.1:"$1"
}

unproxy(){
   unset http_proxy
   unset https_proxy
}


lazy_load() {
    # Act as a stub to another shell function/command. When first run, it will load the actual function/command then execute it.
    # E.g. This made my zsh load 0.8 seconds faster by loading `nvm` when "nvm", "npm" or "node" is used for the first time
    # $1: space separated list of alias to release after the first load
    # $2: file to source
    # $3: name of the command to run after it's loaded
    # $4+: argv to be passed to $3
    echo "Lazy loading $1 ..."

    # $1.split(' ') using the s flag. In bash, this can be simply ($1) #http://unix.stackexchange.com/questions/28854/list-elements-with-spaces-in-zsh
    # Single line won't work: local names=("${(@s: :)${1}}"). Due to http://stackoverflow.com/questions/14917501/local-arrays-in-zsh   (zsh 5.0.8 (x86_64-apple-darwin15.0))
    local -a names
    if [[ -n "$ZSH_VERSION" ]]; then
        names=("${(@s: :)${1}}")
    else
        names=($1)
    fi
    unalias "${names[@]}"
    . $2
    shift 2
    $*
}

group_lazy_load() {
    local script
    script=$1
    shift 1
    for cmd in "$@"; do
        alias $cmd="lazy_load \"$*\" $script $cmd"
    done
}

# copy filepath
# 在终端中将文件拷贝到系统粘贴板
# 然后可以直接command+v粘贴到微信
# realpath指令通过brew install coreutils安装
copy(){
    if [[ -z "$1" ]]; then
        echo "usage: copy filename"
        return 1
    fi

    # get file absolute path
    file=$(realpath  "$1")

    osascript -e "tell app \"Finder\" to set the clipboard to ( POSIX file \"$file\" )"
}

# paste 复制到当前目录
# paste filename 复制到指定文件
# paste screenshot.png 截图粘贴为文件screenshot.png
# 文本直接pbaste
# 截图生成文件 配合vim写markdown可以快速插入截图
# copy命令复制的文件可以直接通过paste粘贴
# command+c的文件被解释为text无法通过paste复制出来
paste(){
    if [[ ! -z "$1" ]]; then
        save_path="$1"
    else
        save_path="."
    fi
    type="$(osascript -e 'class of (the clipboard)')"

    # 文本类型
    if [[ "$type" == "text" ]];then
        [[ "$save_path" !=  "." ]] && pbpaste >> "$save_path"
        pbpaste
        return 0
    fi

    # 文件类型
    if [[ "$type" == "«class furl»" ]];then
        copy_path="$(osascript -e 'POSIX path of (the clipboard)')"
        [[ -f "$copy_path" ]] && cp "$copy_path" "$save_path"
        [[ -d "$copy_path" ]] && cp -r "$copy_path" "$save_path"
        return 0
    fi
    
    # 截图类型
    [[ "$save_path" == "." ]] && save_path="paste-$(date +%s).png"
    touch "$save_path"
    osascript -e "
set myFile to (open for access \"${save_path}\" with write permission)
write (the clipboard as «class PNGf») to  myFile
close access myFile
"
}

