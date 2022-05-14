FROM manjarolinux/base as nvim-builder

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git neovim nodejs npm yarn go tree

ENV DOTFILES=/root/dotfiles CONF=/root/.config

# my.nvim 
RUN sh -c $'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## minimal nvim config and install plugins
COPY vim/my.nvim/init.vim $CONF/nvim/init.vim
COPY vim/my.nvim/autoload $CONF/nvim/autoload
COPY vim/my.nvim/snapshot.vim $CONF/nvim/snapshot.vim
RUN nvim --headless +RollBack +qall # install  plugin from the command line
RUN nvim --headless +'TSInstallSync all' +qall # install treesitter parsers
RUN nvim --headless +'call CocInstallAll()' +qall # install  plugin from the command line

# debug
#RUN pacman -S --noconfirm tree && tree -d /root/.config/mynvim/coc

FROM manjarolinux/base as zsh-builder

RUN pacman -Syu --noconfirm && pacman -S --noconfirm  zsh git

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

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git nodejs npm yarn python typescript
RUN pacman -Syu --noconfirm && pacman -S --noconfirm ctags python-pynvim
RUN yarn global add neovim

RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
zsh neovim vim vifm ripgrep fzf tig ncdu tmux bottom tree bat trash-cli \
ccls lua-language-server gopls delve man jq fd rust-analyzer

RUN /usr/bin/cargo install loc

RUN pacman -Syu --noconfirm && pacman -S --noconfirm  openssh && ssh-keygen -A
RUN chsh -s /bin/zsh

# https://github.com/rust-lang/cargo/issues/7515
#ENV CARGO_HTTP_MULTIPLEXING false
ENV USERNAME=vimer
ENV MHOME=/home/${USERNAME}
ENV HOMEBAK=${HOME}
ENV HOME=${MHOME}

RUN useradd -s /bin/zsh -m ${USERNAME} && echo "${USERNAME} ALL=(ALL)   ALL" >> /etc/sudoers

COPY --from=nvim-builder /root/.config/mynvim ${MHOME}/.config/mynvim
COPY --from=nvim-builder /root/.local/share/nvim/site/autoload ${MHOME}/.local/share/nvim/site/autoload
COPY --from=zsh-builder /root/.zinit ${MHOME}/.zinit

RUN pacman -Syu --noconfirm && pacman -S --noconfirm go rust
RUN /usr/bin/cargo install --locked navi
RUN /usr/bin/cargo install loc

ENV DOTFILES=${MHOME}/dotfiles CONF=${MHOME}/.config

RUN mkdir /data
WORKDIR ${MHOME}
COPY . dotfiles
RUN cd dotfiles && sh bootstrap.sh

ENV HOME=${HOMEBAK}

# if use zsh the user will be vimer, but why ?
#ENTRYPOINT ["zsh","/home/vimer/dotfiles/docker-entrypoint.sh"]
ENTRYPOINT ["sh","/home/vimer/dotfiles/docker-entrypoint.sh"]

