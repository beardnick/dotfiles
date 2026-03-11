# vim: set expandtab shiftwidth=4 foldmethod=marker foldlevel=0 :
#!/usr/bin/env bash
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

# }} }

if [ "$(uname -s)" = "Darwin" ]; then
    DISTRIBUTION="macos"
elif [ -f /etc/os-release ]; then
    . /etc/os-release
    DISTRIBUTION="$ID"
else
    DISTRIBUTION="unknown"
fi

case "$DISTRIBUTION" in
    "ubuntu")
        # no runtime dependency needed now
        ;;
    "macos")
        if ! command -v brew >/dev/null 2>&1; then
            echo "error: Homebrew is required on macOS. Install it from https://brew.sh/"
            exit 1
        fi
        ;;
    *)
        echo "info: running on $DISTRIBUTION"
        ;;
esac

DOTDIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CONF="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

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

echo "bootstrap completed"
