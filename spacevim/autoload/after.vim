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

" 手动折叠更灵活，可以使用zfi() zfi{ 之类的命令
set foldmethod=manual

noremap <C-F> :<C-U>call SpaceVim#mapping#search#grep("a", "P")<CR>


imap <C-K> <Plug>(neosnippet_jump)

" <C-U>用于防止在可视模式中使用范围
nnoremap <M-Down> :<C-U>cnext<CR>
nnoremap <M-UP> :<C-U>cprevious<CR>
nnoremap gd :<C-U>GtagsCursor<CR>
nnoremap zf{ zfi{
nnoremap zf( zfi(
nnoremap zf[ zfi[
nnoremap zf" zfi"
nnoremap zf' zfi'
nnoremap <expr> GG ":echom ".screencol()."\n"
nnoremap <silent> GG :echom screencol()<CR>

nmap <CR> <Plug>(wildfire-fuel)
let g:wildfire_objects = {
    \ "*" : ["i'", 'i"', "i)", "i]", "i}"],
    \ "html,xml" : ["at", "it"],
    \ }


" denite option
let s:denite_options = {
      \ 'default' : {
      \ 'winheight' : 15,
      \ 'mode' : 'insert',
      \ 'quit' : 'true',
      \ 'highlight_matched_char' : 'MoreMsg',
      \ 'highlight_matched_range' : 'MoreMsg',
      \ 'direction': 'rightbelow',
      \ 'statusline' : has('patch-7.4.1154') ? v:false : 0,
      \ 'prompt' : '➭',
      \ }}

function! s:profile(opts) abort
  for fname in keys(a:opts)
    for dopt in keys(a:opts[fname])
      call denite#custom#option(fname, dopt, a:opts[fname][dopt])
    endfor
  endfor
endfunction

call s:profile(s:denite_options)

noremap <C-P> :<C-U>Denite file/rec<CR>
nnoremap <C-+> <C-W>+

" KEY MAPPINGS
let s:insert_mode_mappings = [
      \  ['jk', '<denite:enter_mode:normal>', 'noremap'],
      \ ['<Tab>', '<denite:move_to_next_line>', 'noremap'],
      \ ['<S-tab>', '<denite:move_to_previous_line>', 'noremap'],
      \  ['<Esc>', '<denite:enter_mode:normal>', 'noremap'],
      \  ['<C-N>', '<denite:assign_next_matched_text>', 'noremap'],
      \  ['<C-P>', '<denite:assign_previous_matched_text>', 'noremap'],
      \  ['<Up>', '<denite:assign_previous_text>', 'noremap'],
      \  ['<Down>', '<denite:assign_next_text>', 'noremap'],
      \  ['<C-Y>', '<denite:redraw>', 'noremap'],
      \ ]

let s:normal_mode_mappings = [
      \   ["'", '<denite:toggle_select_down>', 'noremap'],
      \   ['<C-n>', '<denite:jump_to_next_source>', 'noremap'],
      \   ['<C-p>', '<denite:jump_to_previous_source>', 'noremap'],
      \   ['gg', '<denite:move_to_first_line>', 'noremap'],
      \   ['st', '<denite:do_action:tabopen>', 'noremap'],
      \   ['sg', '<denite:do_action:vsplit>', 'noremap'],
      \   ['sv', '<denite:do_action:split>', 'noremap'],
      \   ['q', '<denite:quit>', 'noremap'],
      \   ['r', '<denite:redraw>', 'noremap'],
      \ ]

for s:m in s:insert_mode_mappings
  call denite#custom#map('insert', s:m[0], s:m[1], s:m[2])
endfor
for s:m in s:normal_mode_mappings
  call denite#custom#map('normal', s:m[0], s:m[1], s:m[2])
endfor

function! WindLineLeft(column) abort
  if a:column > 50
			exe 5 . "wincmd >"
  else
			exe 5 . "wincmd <"
  endif
endfunction

function! WindLineRight(column) abort
  if a:column > 50
			exe 5 . "wincmd <"
  else
			exe 5 . "wincmd >"
  endif
endfunction


function! WindLineUp(row) abort
  if a:row > 50
      exe 5 "wincmd +"
  else
    exe 5 "wincmd -"
  endif
endfunction


function! WindLineDown(row) abort
  if a:row > 50
      exe 5 "wincmd -"
  else
    exe 5 "wincmd +"
  endif
endfunction

noremap <expr> <C-H> ":<C-U>call WindLineLeft(" .screencol() . ")\n"
noremap <expr> <C-L> ":<C-U>call WindLineRight(" .screencol() . ")\n"
noremap <expr> <C-K> ":<C-U>call WindLineUp(" .screenrow() . ")\n"
noremap <expr> <C-J> ":<C-U>call WindLineDown(" .screenrow() . ")\n"

" function! WindLineRight() abort() abort
"
" endfunction

unlet s:m s:insert_mode_mappings s:normal_mode_mappings
