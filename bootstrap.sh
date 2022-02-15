#!/usr/bin/env bash

CONF="$HOME/.config"

if [ ! -d "$CONF" ];then
	mkdir -p "$CONF"
fi

# ideavim
ln -s idea/.ideavimrc "$HOME/.ideavimrc"

# .zshrc .zsh_history
ln -s  "$(pwd)/shell/zsh" "$CONF/zsh"
ln -s  "$(pwd)/shell/.zshrc" "$HOME/.zshrc"

# .tmux.conf
ln -s  tmux/.tmux.conf "$HOME/.tmux.conf"
ln -s  tmux/.tmux.conf.local "$HOME/.tmux.conf.local"

# vim
ln -s vim/.vimlite "$HOME/.vimlite.vim"
