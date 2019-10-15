let mapleader = ","

set statusline=%F\ >\ %y
set number
set nowrap

" 使光标始终在屏幕中间
set sidescrolloff=999
set scrolloff=999


" 更快地复制粘帖到系统粘贴板上
noremap <leader>y "+y
noremap <leader>p "+p

noremap <SPACE>w <C-W>

inoremap jk <ESC>
inoremap jj <ESC>
inoremap kk <ESC>

" 使用语法折叠
set foldmethod=syntax
set foldlevelstart=99

" 编辑配置文件
nnoremap <Leader>ev :vsplit ~/.vimlite.vim<cr>
" 加载配置文件
nnoremap <Leader>sv :source ~/.vimlite.vim<cr>

" 使用/匹配的时候实时显示匹配到的内容
set incsearch
set ignorecase

set tabstop=4
set shiftwidth=4
set expandtab
set autoindent

" 简单的文件浏览器使用
nnoremap <C-E> :<C-U>20Lexplore<CR>

set path+=**

