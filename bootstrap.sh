#!/usr/bin/env bash

CONF="$HOME/.config"

if [ ! -d "$CONF" ];then
	mkdir -p "$CONF"
fi

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
ln -s "$DOTDIR/vim/.vimlite" "$HOME/.vimlite.vim"
