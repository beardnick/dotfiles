FROM manjarolinux/base as nvim-builder

RUN pacman-mirrors -c China -m rank && pacman -Syyu --noconfirm && pacman -S --noconfirm git neovim nodejs npm yarn go tree

ENV DOTFILES=/root/dotfiles CONF=/root/.config

# my.nvim 
RUN sh -c $'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
RUN npm config set registry https://registry.npm.taobao.org
RUN yarn config set registry https://registry.npm.taobao.org

## minimal nvim config and install plugins
COPY vim/my.nvim/init.vim $CONF/nvim/init.vim
COPY vim/my.nvim/autoload $CONF/nvim/autoload
COPY vim/my.nvim/snapshot.vim $CONF/nvim/snapshot.vim
RUN nvim --headless +RollBack +qall # install  plugin from the command line
RUN nvim --headless +'call CocInstallAll()' +qall # install  plugin from the command line

# debug
#RUN pacman -S --noconfirm tree && tree -d /root/.config/mynvim/coc

FROM manjarolinux/base as zsh-builder

RUN pacman-mirrors -c China -m rank && pacman -Syyu --noconfirm && pacman -S --noconfirm  zsh git

ENV DOTFILES=/root/dotfiles CONF=/root/.config

WORKDIR /root
COPY shell dotfiles/shell
RUN mkdir -p $CONF \
&& ln -s  "$DOTFILES/shell/zsh" "$CONF/zsh" \
&& ln -s  "$DOTFILES/shell/.zshrc" "$HOME/.zshrc" \
&& zsh -i $HOME/.zshrc

# debug
#RUN pacman -S --noconfirm tree && tree -d .zinit

FROM manjarolinux/base as dev-env

RUN pacman-mirrors -c China -m rank && \
pacman -Syyu --noconfirm && pacman -S --noconfirm git nodejs npm yarn go python typescript rust

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

RUN usr/bin/cargo install --locked navi

COPY --from=nvim-builder /root/.config/mynvim /root/.config/mynvim
COPY --from=nvim-builder /root/.local/share/nvim/site/autoload /root/.local/share/nvim/site/autoload
COPY --from=zsh-builder /root/.zinit /root/.zinit


RUN pacman -S --noconfirm ctags python-pynvim
RUN yarn global add neovim

# https://github.com/rust-lang/cargo/issues/7515
#ENV CARGO_HTTP_MULTIPLEXING false

ENV DOTFILES=/root/dotfiles CONF=/root/.config

WORKDIR /root
COPY . dotfiles
RUN cd dotfiles && sh bootstrap.sh

RUN mkdir /data

RUN pacman -S --noconfirm zsh neovim vim vifm ripgrep fzf tig ncdu tmux bottom tree bat trash-cli 

RUN pacman -S --noconfirm  openssh && ssh-keygen -A
RUN chsh -s /bin/zsh


ENTRYPOINT ["zsh","/root/dotfiles/docker-entrypoint.sh"]

