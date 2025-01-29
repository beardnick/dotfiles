const path = require('path');
const fs = require('fs');

function ensureDir(dir) {
  if (fs.existsSync(dir)) {
    return;
  }
  fs.mkdirSync(dir, {recursive: true});
}

async function ensureAllLink(src, dst) {
  const files = await glob(`${src}/*`);
  for (const f of files) {
    ensureLink(f, `${dst}/${path.basename(f)}`)
  }
}

function ensureLink(src, dst) {
  if (fs.existsSync(dst)) {
    const stats = fs.lstatSync(dst);
    if (stats.isSymbolicLink()) {
      return;
    }
    throw new Error(`${dst} exists and not symbol link`);
  }
  fs.symlinkSync(src, dst);
}

const conf = `${process.env.HOME}/.config`;
const localBin = `${process.env.HOME}/.local/bin`;
const dotdir = (await $`pwd`).stdout.trimEnd();

ensureDir(conf);

// ideavim
ensureLink(`${dotdir}/idea/.ideavimrc`, `${process.env.HOME}/.ideavimrc`);

// .zshrc .zsh_history
ensureLink(`${dotdir}/shell/zsh`, `${conf}/zsh`);
ensureLink(`${dotdir}/shell/.zshrc`, `${process.env.HOME}/.zshrc`);

// .tmux.conf
ensureLink(`${dotdir}/tmux/.tmux.conf`, `${process.env.HOME}/.tmux.conf`);
ensureLink(`${dotdir}/tmux/.tmux.conf.local`, `${process.env.HOME}/.tmux.conf.local`);

// vim
ensureLink(`${dotdir}/vim/.vimlite.vim`, `${process.env.HOME}/.vimlite.vim`);
ensureLink(`${dotdir}/vim/my.nvim`, `${process.env.HOME}/.config/nvim`);

// vifm
ensureLink(`${dotdir}/vifm`, `${process.env.HOME}/.config/vifm`);

// navi

ensureLink(`${dotdir}/navi`, `${process.env.HOME}/.config/navi`);

ensureDir(localBin);

// tiny scripts
ensureAllLink(`${dotdir}/bin`, localBin);
