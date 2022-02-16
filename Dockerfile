FROM archlinux:base-devel-20220206.0.46909

RUN cp /etc/pacman.d/mirrorlist /etc/pacman.d/mirrorlist.backup
# add archlinux cn mirrors
RUN echo \
	$'Server = https://mirrors.tuna.tsinghua.edu.cn/archlinux/$repo/os/$arch\n\
	Server = http://mirrors.163.com/archlinux/$repo/os/$arch\n\
	Server = http://mirrors.aliyun.com/archlinux/$repo/os/$arch\n'\
	> /etc/pacman.d/mirrorlist

RUN pacman -Sy --noconfirm

# shell
RUN pacman -S --noconfirm  zsh
RUN pacman -S --noconfirm  git
# language
RUN pacman -S --noconfirm  python typescript  
# useful cli tools
RUN pacman -S --noconfirm vim neovim vifm ripgrep fzf tig ncdu tmux
# golang and rust is big,so download divided
# golang
RUN pacman -S --noconfirm  go 
# rust
RUN pacman -S --noconfirm  rust

# https://github.com/rust-lang/cargo/issues/7515
ENV CARGO_HTTP_MULTIPLEXING false

RUN mkdir $HOME/.cargo && echo \
	$'[source.crates-io]\n\
	registry = "https://github.com/rust-lang/crates.io-index"\n\
	\n\
	replace-with = \'tuna\'\n\
	\n\
	[source.ustc]\n\
	registry = "https://mirrors.ustc.edu.cn/crates.io-index"\n\
	[source.tuna]\n\
	registry = "https://mirrors.tuna.tsinghua.edu.cn/git/crates.io-index.git"\n\
	[source.rustcc]\n\
	registry = "https://code.aliyun.com/rustcc/crates.io-index.git"\n'\
	> $HOME/.cargo/config

RUN usr/bin/cargo install bottom
RUN usr/bin/cargo install --locked navi
RUN pacman -S --noconfirm  bat
WORKDIR /root
RUN git clone https://github.com/beardnick/dotfiles.git
RUN cd dotfiles && bash bootstrap.sh
WORKDIR /root