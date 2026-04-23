#!/usr/bin/env bash
# vim: set expandtab shiftwidth=4 foldmethod=marker foldlevel=0 :
set -euo pipefail

# {{{ libs

ensure_dir() {
    local dir="$1"
    mkdir -p "$dir"
}

ensure_link() {
    local src="$1"
    local dst="$2"

    if [ -L "$dst" ]; then
        return
    fi

    if [ -e "$dst" ]; then
        echo "error: $dst exists and is not a symlink"
        exit 1
    fi

    ln -s "$src" "$dst"
}

ensure_all_link() {
    local src_dir="$1"
    local dst_dir="$2"

    ensure_dir "$dst_dir"

    local f
    for f in "$src_dir"/*; do
        [ -e "$f" ] || continue
        ensure_link "$f" "$dst_dir/$(basename "$f")"
    done
}

ensure_source_line() {
    local file_path="$1"
    local source_line="$2"

    if [ ! -f "$file_path" ]; then
        printf '%s\n' "$source_line" > "$file_path"
        return
    fi

    if grep -Fxq "$source_line" "$file_path"; then
        return
    fi

    printf '%s\n' "$source_line" >> "$file_path"
}

usage() {
    cat <<'EOF'
Usage: ./bootstrap.sh [command]

Commands:
    bootstrap      Install dependencies and link dotfiles (default)
    deps           Install dependency tools only
    install-deps   Install dependency tools only
    help           Show this help
EOF
}

apt_get() {
    if [ "$(id -u)" -eq 0 ]; then
        apt-get "$@"
        return
    fi

    if ! command -v sudo >/dev/null 2>&1; then
        echo "error: sudo is required when not running as root"
        exit 1
    fi

    sudo apt-get "$@"
}

ensure_cargo() {
    if command -v cargo >/dev/null 2>&1; then
        return
    fi

    case "$DISTRIBUTION" in
        "ubuntu")
            apt_get install -y cargo
            ;;
        *)
            echo "error: cargo is required to install Rust tools on $DISTRIBUTION"
            exit 1
            ;;
    esac
}

install_cargo_tool() {
    local command_name="$1"
    local package_name="$2"

    if command -v "$command_name" >/dev/null 2>&1; then
        return
    fi

    ensure_cargo
    cargo install --locked "$package_name"
    export PATH="$CARGO_BIN:$PATH"
}

install_dependencies() {
    case "$DISTRIBUTION" in
        "ubuntu")
            if ! command -v apt-get >/dev/null 2>&1; then
                echo "error: apt-get is required on Ubuntu"
                exit 1
            fi

            apt_get update
            apt_get install -y fzf fd-find ripgrep lua5.1 bat
            if ! command -v btm >/dev/null 2>&1 && ! apt_get install -y btm; then
                install_cargo_tool btm bottom
            fi
            install_cargo_tool navi navi
            ;;
        "macos")
            if ! command -v brew >/dev/null 2>&1; then
                echo "error: Homebrew is required on macOS. Install it from https://brew.sh/"
                exit 1
            fi

            brew install fzf fd ripgrep lua bat navi bottom
            ;;
        *)
            echo "error: dependency installation is only supported on Ubuntu and macOS"
            exit 1
            ;;
    esac
}

bootstrap_dotfiles() {
    ensure_dir "$CONF"

    # ideavim
    ensure_link "$DOTDIR/idea/.ideavimrc" "$HOME/.ideavimrc"

    # zsh
    ensure_link "$DOTDIR/shell/zsh" "$CONF/zsh"
    ensure_source_line "$HOME/.zshrc" "source \"$CONF/zsh/core.zsh\""

    # tmux
    ensure_link "$DOTDIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
    ensure_link "$DOTDIR/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"

    # vim
    ensure_link "$DOTDIR/vim/.vimlite.vim" "$HOME/.vimlite.vim"
    ensure_link "$DOTDIR/vim/my.nvim" "$CONF/nvim"

    # vifm
    ensure_link "$DOTDIR/vifm" "$CONF/vifm"

    # navi
    ensure_link "$DOTDIR/navi" "$CONF/navi"

    # tiny scripts
    ensure_all_link "$DOTDIR/bin" "$LOCAL_BIN"
}

# }} }

if [ "$(uname -s)" = "Darwin" ]; then
    DISTRIBUTION="macos"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRIBUTION="$ID"
else
    DISTRIBUTION="unknown"
fi

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"
CARGO_BIN="$HOME/.cargo/bin"
export PATH="$CARGO_BIN:$PATH"
COMMAND="${1:-bootstrap}"

case "$COMMAND" in
    "bootstrap")
        install_dependencies
        bootstrap_dotfiles
        echo "bootstrap completed"
        ;;
    "deps"|"install-deps")
        install_dependencies
        echo "dependencies installed"
        ;;
    "help"|"-h"|"--help")
        usage
        ;;
    *)
        usage
        exit 1
        ;;
esac
