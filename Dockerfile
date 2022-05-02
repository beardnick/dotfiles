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

RUN pacman -Syu --noconfirm && pacman -S --noconfirm git nodejs npm yarn go python typescript rust

RUN /usr/bin/cargo install --locked navi

COPY --from=nvim-builder /root/.config/mynvim /root/.config/mynvim
COPY --from=nvim-builder /root/.local/share/nvim/site/autoload /root/.local/share/nvim/site/autoload
COPY --from=zsh-builder /root/.zinit /root/.zinit


RUN pacman -Syu --noconfirm && pacman -S --noconfirm ctags python-pynvim
RUN yarn global add neovim

# https://github.com/rust-lang/cargo/issues/7515
#ENV CARGO_HTTP_MULTIPLEXING false

ENV DOTFILES=/root/dotfiles CONF=/root/.config

WORKDIR /root
COPY . dotfiles
RUN cd dotfiles && sh bootstrap.sh

RUN mkdir /data

RUN pacman -Syu --noconfirm && pacman -S --noconfirm \
zsh neovim vim vifm ripgrep fzf tig ncdu tmux bottom tree bat trash-cli \
ccls lua-language-server gopls delve man jq fd rust-analyzer

RUN /usr/bin/cargo install loc

RUN pacman -Syu --noconfirm && pacman -S --noconfirm  openssh && ssh-keygen -A
RUN chsh -s /bin/zsh

# user out docker can add self to root group to access data volume files
# usermod -aG root $USER
RUN umask 002

ENTRYPOINT ["zsh","/root/dotfiles/docker-entrypoint.sh"]

