FROM archlinux:latest as base-builder

ENV BUILDER=vimer
ENV HOME=/home/${BUILDER}
ENV DOTFILES=${HOME}/dotfiles
ENV CONF=${HOME}/.config

RUN pacman -Syu --noconfirm \
    && pacman -S --noconfirm --needed git base-devel \
    && useradd -s /bin/bash -u 65533 -m ${BUILDER} \
    && echo "${BUILDER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers

USER ${BUILDER}
RUN echo "run as $(whoami)" \
    && cd /home/${BUILDER} \
    && git clone https://aur.archlinux.org/yay-bin.git \
    && cd yay-bin \
    && makepkg -si --noconfirm \
    && yay -S --noconfirm nvm \
    && source /usr/share/nvm/init-nvm.sh \
    && nvm install 17 \
    && npm install -g yarn

FROM base-builder as nvim-builder

RUN sudo pacman -S --noconfirm neovim go tree

# my.nvim 
RUN sh -c $'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim \
--create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

## minimal nvim config and install plugins
COPY vim/my.nvim/init.vim ${CONF}/nvim/init.vim
COPY vim/my.nvim/autoload ${CONF}/nvim/autoload
COPY vim/my.nvim/snapshot.vim ${CONF}/nvim/snapshot.vim
RUN tree ${CONF}
RUN source /usr/share/nvm/init-nvm.sh \
    && nvim --headless +RollBack +qall # install  plugin from the command line
RUN nvim --headless +'TSInstallSync all' +qall # install treesitter parsers

RUN source /usr/share/nvm/init-nvm.sh \
    && nvim --headless +'call CocInstallAll()' +qall # install  plugin from the command line

# debug
#RUN pacman -S --noconfirm tree && tree -d /root/.config/mynvim/coc

FROM base-builder as zsh-builder

RUN sudo pacman -S --noconfirm zsh 

WORKDIR ${HOME}
COPY shell dotfiles/shell
RUN mkdir -p $CONF \
&& ln -s  "$DOTFILES/shell/zsh" "$CONF/zsh" \
&& ln -s  "$DOTFILES/shell/.zshrc" "$HOME/.zshrc" \
&& zsh -i $HOME/.zshrc

# debug
#RUN pacman -S --noconfirm tree && tree -d .zinit

FROM base-builder as dev-env

RUN sudo pacman -S --noconfirm python typescript ctags python-pynvim \
    zsh neovim vim vifm ripgrep fzf tig ncdu tmux bottom tree bat trash-cli \
    ccls lua-language-server gopls delve man jq fd rust-analyzer rustup \
    && source /usr/share/nvm/init-nvm.sh \
    && npm install -g neovim

RUN rustup install stable \
    && /usr/bin/cargo install loc \
    && /usr/bin/cargo install --locked navi

RUN sudo pacman -S --noconfirm  openssh && ssh-keygen -A
RUN sudo chsh -s /bin/zsh ${BUILDER}
RUN echo "source /usr/share/nvm/init-nvm.sh" >> ${HOME}/.zshenv

# https://github.com/rust-lang/cargo/issues/7515
#ENV CARGO_HTTP_MULTIPLEXING false

COPY --from=nvim-builder ${HOME}/.config/mynvim ${HOME}/.config/mynvim
COPY --from=nvim-builder ${HOME}/.local/share/nvim/site/autoload ${HOME}/.local/share/nvim/site/autoload
COPY --from=zsh-builder ${HOME}/.zinit ${HOME}/.zinit

ENV DOTFILES=${HOME}/dotfiles CONF=${HOME}/.config

RUN sudo mkdir /data
COPY . ${DOTFILES}
RUN cd ${DOTFILES} && sh bootstrap.sh

USER root
# if use zsh the user will be vimer, but why ?
#ENTRYPOINT ["zsh","/home/vimer/dotfiles/docker-entrypoint.sh"]
ENTRYPOINT ["sh","/home/vimer/dotfiles/docker-entrypoint.sh"]

