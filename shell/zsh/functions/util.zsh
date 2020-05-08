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

