# vim: set expandtab shiftwidth=4 foldmethod=marker foldlevel=0 :
#!/usr/bin/env bash

# {{{ libs

function setup_ubuntu(){
    local gui_mode="${1:-false}"
    sudo apt update -y
    sudo apt install -y \
        nodejs \
        zx
}

# }}}

if [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRIBUTION="$ID"
    DISTRIBUTION_VERSION="$VERSION_ID"
else
    echo "unknown distribution"
fi

case "$DISTRIBUTION" in 
    "ubuntu")
        setup_ubuntu
        ;;
    *)
        echo "unknonw func"
esac

zx bootstrap.mjs "$@"
