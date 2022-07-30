if exists('g:vscode')
    execute 'source' fnamemodify(expand('<sfile>'), ':h').'/vscode.vim'
    finish
endif

"nvim总是不兼容vi的
if &compatible
    set nocompatible
endif

let &runtimepath.=",~/.config/nvim"

let g:plugin_dir=expand('$HOME/.config/mynvim')
let g:coc_data_home = g:plugin_dir . '/coc'
let g:mynvim_root_path = fnamemodify(resolve(expand('<sfile>:p')), ':h')
let g:mynvim_config_default=g:mynvim_root_path . '/default.vim'
let g:mynvim_config_before=expand('$HOME/.mynvim_config_before.vim')
let g:mynvim_config_after=expand('$HOME/.mynvim_config_after.vim')

set wildignore+=*.o,*.obj,*/.ccls-cache/*,*/vendor/*
set wildignore+=*/node_modules/*,_site,*/__pycache__/,*/venv/*,*/target/*,*/.vim$,\~$,*/.log,*/.aux,*/.cls,*/.aux,*/.bbl,*/.blg,*/.fls,*/.fdb*/,*/.toc,*/.out,*/.glo,*/.log,*/.ist,*/.fdb_latexmk


let g:plug_retries=5
call plug#begin(g:plugin_dir)

    Plug 'morhetz/gruvbox' " 主题
    Plug 'mg979/vim-visual-multi' 
    Plug 'luochen1990/rainbow'
    " 注意编译问题，很多时候编译出错了很多插件都会有问题
    " 大部分时候可以通过call coc#util#install()解决问题
    Plug 'neoclide/coc.nvim', {'branch': 'master', 'do': 'yarn install --frozen-lockfile'}
    " 自动tag生成与管理
    Plug 'ludovicchabant/vim-gutentags'
    "Plug 'skywind3000/gutentags_plus'
    " leaderf用来搜索
    "call dein#add('Yggdroot/LeaderF')
    Plug 'mhinz/vim-startify'
    Plug 'scrooloose/nerdcommenter'
    "Plug 'fatih/vim-go'
    " 两个代码模版的插件要一起装，只复制代码模版文件可能会造成找不到vimsnippets模块
    Plug 'SirVer/ultisnips'
    " 使用自己fork的snippets
    Plug 'honza/vim-snippets'
    Plug 'plasticboy/vim-markdown'
    Plug 'iamcco/markdown-preview.nvim', { 'do': 'cd app & yarn install'  }
    Plug 'dhruvasagar/vim-table-mode'
    Plug 'gcmt/wildfire.vim'
    Plug 'tpope/vim-surround'
    Plug 'tpope/vim-repeat'
    Plug 'Krasjet/auto.pairs'
    Plug 'godlygeek/tabular'
    " 三个插件加起来有最好的文件搜索体验
    Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
    Plug 'junegunn/fzf.vim'
    Plug 'tweekmonster/fzf-filemru'
    Plug 'Yggdroot/indentLine'
    Plug 'tyru/open-browser.vim'
    Plug 'airblade/vim-rooter'
    " 切换自定义格式的工具
    Plug 'AndrewRadev/switch.vim'
    "Plug 'ap/vim-buftabline'
    Plug 'kyazdani42/nvim-web-devicons'
    Plug 'romgrk/barbar.nvim'

    Plug 'junegunn/goyo.vim'
    Plug 'freitass/todo.txt-vim'
    " 提供了一些好用的command用于调试vimscript
    Plug 'tpope/vim-scriptease'
    " 在vim中访问各种数据库
    Plug 'tpope/vim-dadbod'
    Plug 'tpope/vim-dispatch'
    Plug 'andymass/vim-matchup'
    "添加tmux框中文字的补全源
    Plug 'wellle/tmux-complete.vim'
    "记录上一次打开文件的位置
    "它会使jumplist出问题
    "Plug 'farmergreg/vim-lastplace'
    "全局修改插件
    "Plug 'brooth/far.vim'
    " vimtex viewer 带了实时预览的功能
    Plug 'lervag/vimtex'
    Plug 'skywind3000/vim-quickui'
    Plug 'skywind3000/asynctasks.vim'
    Plug 'skywind3000/asyncrun.vim'
    Plug 'skywind3000/vim-keysound'
    Plug 'aperezdc/vim-template'
    Plug 'zenbro/mirror.vim' 
    Plug 'antoinemadec/coc-fzf' 
    Plug 'liuchengxu/vista.vim' 
    "Plug 'puremourning/vimspector' 
    Plug 'dearrrfish/vim-applescript' 
    Plug 'skywind3000/vim-dict'
    Plug 'kristijanhusak/vim-dadbod-ui'
    Plug 'akiyosi/gonvim-fuzzy'
    Plug 'joshdick/onedark.vim'
    Plug 'challenger-deep-theme/vim',{'name':'challenger-deep-theme'} 
    Plug 'sickill/vim-monokai' " monokai theme
    Plug 'kurkale6ka/vim-swap' " visualmode <Leader>x交换位置
    Plug 'tpope/vim-dotenv'
    "Plug 'itchyny/lightline.vim'
    Plug 'nvim-lualine/lualine.nvim'
    Plug 'rakr/vim-one'
    Plug 'tomasiser/vim-code-dark' " vscode主题
    Plug 'markonm/traces.vim' " 在命令模式中高亮正则表达式
    Plug 't9md/vim-choosewin'
    Plug 'szw/vim-maximizer'
    Plug 'wellle/targets.vim' " 千奇百怪的textobject支持
    Plug 'rizzatti/dash.vim'
    Plug 'drmikehenry/vim-fixkey'
    Plug 'posva/vim-vue'
    Plug 'easymotion/vim-easymotion' " 快速跳转
    Plug 'yuki-yano/fzf-preview.vim', { 'branch': 'release/rpc' }
    Plug 'NLKNguyen/papercolor-theme'
    Plug 'challenger-deep-theme/vim', { 'as': 'challenger-deep' }
    Plug 'liuchengxu/space-vim-dark'
    Plug 'hzchirs/vim-material'
    Plug 'patstockwell/vim-monokai-tasty'
    Plug 'unblevable/quick-scope'
    Plug 'MattesGroeger/vim-bookmarks'
    Plug 'beardnick/mynvim', {'do':'make'}
    Plug 'tpope/vim-fugitive'
    Plug 'ilyachur/cmake4vim' " generate compile_commands.json for lsp
    Plug 'ojroques/vim-oscyank'
    Plug 'akinsho/toggleterm.nvim'

    " debug
    Plug 'mfussenegger/nvim-dap'
    Plug 'rcarriga/nvim-dap-ui'
    Plug 'leoluz/nvim-dap-go'
    Plug 'sunjon/stylish.nvim'
    Plug 'rcarriga/nvim-notify'

    Plug 'nvim-lua/plenary.nvim'
    Plug 'nvim-telescope/telescope.nvim'
    Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
    Plug 'fannheyward/telescope-coc.nvim'

    Plug 'nvim-treesitter/nvim-treesitter'
    Plug 'xiyaowong/nvim-transparent'
    Plug 'github/copilot.vim'

    Plug 'SmiteshP/nvim-gps'
    Plug 'theHamsta/nvim-dap-virtual-text'

    Plug 'Weissle/persistent-breakpoints.nvim'

    Plug 'nvim-treesitter/playground'
    "Plug 'nvim-treesitter/nvim-treesitter' 
    "Plug 'nvim-treesitter/nvim-treesitter-refactor'
    "Plug 'romgrk/nvim-treesitter-context'
    " 有点慢
    "Plug 'ZSaberLv0/ZFVimIM'
    "Plug 'ZSaberLv0/ZFVimJob' " 用于提升词库加载性能

call plug#end()

let g:coc_global_extensions =['coc-actions@1.5.0'
                            \,'coc-browser@1.5.0'
                            \,'coc-calc@2.1.1'
                            \,'coc-clock@0.0.12'
                            \,'coc-css@1.3.0'
                            \,'coc-dictionary@1.2.2'
                            \,'coc-docker@0.5.0'
                            \,'coc-emmet@1.1.6'
                            \,'coc-explorer@0.22.6'
                            \,'coc-git@2.4.7'
                            \,'coc-gitignore@0.0.4'
                            \,'coc-go@1.1.0'
                            \,'coc-highlight@1.3.0'
                            \,'coc-html@1.6.1'
                            \,'coc-java@1.5.5'
                            \,'coc-json@1.4.1'
                            \,'coc-lines@0.5.0'
                            \,'coc-lists@1.4.2'
                            \,'coc-marketplace@1.8.1'
                            \,'coc-omni@1.2.4'
                            \,'coc-omnisharp@0.0.28'
                            \,'coc-post@0.3.1'
                            \,'coc-pyright@1.1.220'
                            \,'coc-python@1.2.13'
                            \,'coc-rust-analyzer@0.61.0'
                            \,'coc-solargraph@1.2.3'
                            \,'coc-syntax@1.2.4'
                            \,'coc-tag@1.2.5'
                            \,'coc-terminal@0.6.0'
                            \,'coc-todolist@1.5.1'
                            \,'coc-translator@1.7.2'
                            \,'coc-tsserver@1.9.12'
                            \,'coc-ultisnips@1.2.3'
                            \,'coc-vetur@1.2.5'
                            \,'coc-vimlsp@0.12.5'
                            \,'coc-vimtex@1.1.1'
                            \,'coc-xml@1.14.1'
                            \,'coc-yaml@1.6.1'
                            \,'coc-yank@1.2.1'
                            \,'coc-fzf-preview@2.12.8'
                            \,'coc-cmake@0.2.1'
                            \]


silent! execute 'source ' . g:mynvim_config_default
silent! execute 'source ' . g:mynvim_config_before

call utils#source_path(g:mynvim_root_path,"ui")
call utils#source_path(g:mynvim_root_path,"plugin")
call utils#source_path(g:mynvim_root_path,"lang")

silent! execute 'source ' . g:mynvim_config_after
call utils#source_file(g:mynvim_root_path, 'keybinding.vim')

command! Update call UpdateWithSnapshot()
command! RollBack exe "source " . g:mynvim_root_path . "/snapshot.vim"

function! UpdateWithSnapshot() abort
    exe "PlugSnapshot! " . g:mynvim_root_path . "/snapshot.vim"
    exe "PlugUpdate"
endfunction

function! CocInstallAll() abort
    let ext_path = g:coc_data_home . '/extensions'
    execute '!mkdir -p ' . ext_path . ' && cd ' . ext_path. ' && touch package.json && echo ''{"dependencies":{}}'' > package.json  '
    let exts = join(g:coc_global_extensions," ")
    execute '!cd '.ext_path.' && npm install ' . exts .' --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod'
endfunction
