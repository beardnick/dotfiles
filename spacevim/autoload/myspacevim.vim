function! myspacevim#before() abort
  let g:mapleader = ','

     "gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    "let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

     "所生成的数据文件的名称
    "let g:gutentags_ctags_tagfile = '.tags'

     "将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录
    "let s:vim_tags = expand('~/.cache/tags')
    "let g:gutentags_cache_dir = s:vim_tags

     "配置 ctags 的参数
    "let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
    "let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
    "let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

     "检测 ~/.cache/tags 不存在就新建
    "if !isdirectory(s:vim_tags)
       "silent! call mkdir(s:vim_tags, 'p')
    "endif

    "let $GTAGSLABEL = 'native-pygments'
    "let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

endfunction

function! myspacevim#after() abort
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

endfunction
