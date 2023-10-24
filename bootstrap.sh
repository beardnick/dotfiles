#!/usr/bin/env bash


CONF="$HOME/.config"
LOCAL_BIN="$HOME/.local/bin"

function ensure_dir() {
    path="${1:?'path is required'}"
    if [[ -d "$path" ]]; then
        return;
    fi
    mkdir -p "$path"
}

ensure_dir "$CONF"

DOTDIR="$(pwd)"
# ideavim
ln -s "$DOTDIR/idea/.ideavimrc" "$HOME/.ideavimrc"

# .zshrc .zsh_history
ln -s  "$DOTDIR/shell/zsh" "$CONF/zsh"
ln -s  "$DOTDIR/shell/.zshrc" "$HOME/.zshrc"

# .tmux.conf
ln -s  "$DOTDIR/tmux/.tmux.conf" "$HOME/.tmux.conf"
ln -s  "$DOTDIR/tmux/.tmux.conf.local" "$HOME/.tmux.conf.local"

# vim
ln -s "$DOTDIR/vim/.vimlite.vim" "$HOME/.vimlite.vim"
ln -s "$DOTDIR/vim/my.nvim" "$HOME/.config/nvim"

# vifm
ln -s "$DOTDIR/vifm" "$HOME/.config/vifm"

# tiny scripts
ln -s "$DOTDIR/bin" "$LOCAL_BIN"
