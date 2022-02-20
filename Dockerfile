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
RUN pacman -S --noconfirm  bat trash-cli npm yarn
ENV DOTFILES=/root/dotfiles CONF=/root/.config

WORKDIR /root
RUN mkdir dotfiles && mkdir .config
# zsh
COPY shell dotfiles/shell
RUN ln -s  "$DOTFILES/shell/zsh" "$CONF/zsh" \
&& ln -s  "$DOTFILES/shell/.zshrc" "$HOME/.zshrc" \
&& zsh -i $HOME/.zshrc

# my.nvim 
RUN sh -c $'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN npm config set registry https://registry.npm.taobao.org
RUN yarn config set registry https://registry.npm.taobao.org
## install nvim  multi language requires
RUN pacman -S --noconfirm ctags python-pynvim
RUN npm install neovim

## minimal nvim config and install plugins
COPY vim/my.nvim/init.vim $DOTFILES/vim/my.nvim/init.vim
COPY vim/my.nvim/autoload $DOTFILES/vim/my.nvim/autoload
COPY vim/my.nvim/snapshot.vim $DOTFILES/vim/my.nvim/snapshot.vim
RUN ln -s "$DOTFILES/vim/my.nvim" "$CONF/nvim"
RUN nvim --headless +RollBack +qall # install  plugin from the command line
RUN nvim --headless +'call CocInstallAll()' +qall # install  plugin from the command line

RUN mkdir /data

COPY . dotfiles
RUN cd dotfiles && sh bootstrap.sh
RUN pacman -S --noconfirm  openssh && ssh-keygen -A
RUN chsh -s /bin/zsh
ENTRYPOINT ["zsh","/root/dotfiles/docker-entrypoint.sh"]
