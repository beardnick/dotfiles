#!/usr/bin/env bash


CONF="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

function ensure_dir() {
    local path="${1:?'path is required'}"
    if [[ -d "$path" ]]; then
        return;
    fi
    mkdir -p "$path"
}

function link_once() {
    local src="${1:?'src path is required'}"
    local dst="${2:?'dst path is required'}"
    echo "$src => $dst"
    if [[ -e "$dst" ]]; then
        if [[ -L "$dst" ]]; then
            return 0;
        fi
        echo "$dst exists,link failed"
        return 1;
    fi
    ln -s "$src" "$dst"
}

function link_all() {
    local src="${1:?'link all src path is required'}"
    local dst="${2:?'link all dst path is required'}"
    for f in $(find "$src"/*) ; do
        link_once "$f" "$dst/$(basename $f)"
    done
}

ensure_dir "$CONF"

DOTDIR="$(pwd)"
# ideavim
link_once "$DOTDIR/idea/.ideavimrc" "$HOME/.ideavimrc"

# .zshrc .zsh_history
link_once  "$DOTDIR/shell/zsh" "$CONF/zsh"
link_once  "$DOTDIR/shell/.zshrc" "$HOME/.zshrc"

# .tmux.conf
link_once  "$DOTDIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
link_once  "$DOTDIR/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"

# vim
link_once "$DOTDIR/vim/.vimlite.vim" "$HOME/.vimlite.vim"
link_once "$DOTDIR/vim/my.nvim" "$HOME/.config/nvim"

# vifm
link_once "$DOTDIR/vifm" "$HOME/.config/vifm"

# navi

link_once "$DOTDIR/navi" "$HOME/.config/navi"

ensure_dir "$LOCAL_BIN"

# tiny scripts
link_all "$DOTDIR/bin" "$LOCAL_BIN"
