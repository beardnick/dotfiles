iabbrev qq@ 1685437606@qq.com
iabbrev g@ qianzhoubeard@gmail.com

" 快速添加笔记标签
iabbrev note  #note <c-r>=strftime("%y-%m-%d")<cr><esc><plug>NERDCommenterComment<esc>A
iabbrev imp  #imp <c-r>=strftime("%y-%m-%d")<cr><esc><plug>NERDCommenterComment<esc>A
iabbrev todo  #todo <c-r>=strftime("%y-%m-%d")<cr><esc><plug>NERDCommenterComment<esc>A

" 快速注释
nmap <Leader>; <Plug>NERDCommenterToggle
vmap <Leader>; <Plug>NERDCommenterToggle

" 快速切换normal
inoremap jk <esc>
inoremap jj <esc>
inoremap kk <esc>

" 编辑配置文件
nnoremap <Leader>ev :vsplit ~/.SpaceVim.d/autoload/myspacevim.vim<cr>
" 加载配置文件
nnoremap <Leader>sv :source ~/.SpaceVim.d/autoload/myspacevim.vim<cr>

"inoremap note<tab> <c-r>=strftime("%y-%m-%d")<cr>
nnoremap <Leader>w :w<cr>
" 复制粘贴
noremap <Leader>y "+y
noremap <Leader>p "+p<cr>

nnoremap <C-B> :<C-U>exe "Gtags -d " . expand("<cword>")<CR>

nnoremap <m-u> <c-w>p<c-u><c-w>p
nnoremap <m-d> <c-w>p<c-d><c-w>p
nnoremap <C-S-F12> <C-W>o

" 令光标横向纵向移动时始终保持在中央
set sidescrolloff=999
set scrolloff=999
set ignorecase

set foldmethod=syntax
set foldlevelstart=99

noremap <C-F> :<C-U>call SpaceVim#mapping#search#grep("a", "P")<CR>


imap <C-K> <Plug>(neosnippet_jump)

