#!/usr/bin/env bash

CONF="$HOME/.config"

if [ ! -d "$CONF" ];then
	mkdir -p "$CONF"
fi

# ideavim
stow -t "$HOME/" idea

# .zshrc .zsh_history
ln -s  "$(pwd)/shell/zsh" "$CONF/zsh"
ln -s  "$(pwd)/shell/.zshrc" "$HOME/.zshrc"

# .tmux.conf
stow -t "$HOME/" tmux

# vim
stow -t "$HOME/" vim
