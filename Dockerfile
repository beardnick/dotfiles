FROM archlinux:base-devel-20220206.0.46909

RUN  pacman -S --noconfirm base-devel # core utils

RUN pacman -S --noconfirm  zsh # shell
RUN pacman -S --noconfirm  git go python rust typescript # language
RUN pacman -S --noconfirm vim neovim vifm ripgrep fzf tig ncdu tmux # useful cli tools
RUN cargo install bottom
RUN cargo install --locked navi