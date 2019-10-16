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

" 复制粘贴
noremap <Leader>yy "+y
noremap <Leader>ya "ay
noremap <Leader>yb "by
noremap <Leader>yc "cy
noremap <Leader>pp "+p
noremap <Leader>pa "ap
noremap <Leader>pb "bp
noremap <Leader>pc "cp
nnoremap <Leader>rr viw"+p
nnoremap <Leader>ra viw"ap
nnoremap <Leader>rb viw"bp
nnoremap <Leader>rc viw"cp
nnoremap <Leader>rp viwp


noremap <Leader>w :<C-U>set wrap!<CR>
nnoremap <C-B> :<C-U>exe "Gtags -d " . expand("<cword>")<CR>

nnoremap <m-u> <c-w>p<c-u><c-w>p
nnoremap <m-d> <c-w>p<c-d><c-w>p

" 令光标横向纵向移动时始终保持在中央
set sidescrolloff=999
set scrolloff=999
set ignorecase

" 手动折叠更灵活，可以使用zfi() zfi{ 之类的命令
set foldmethod=manual

noremap <C-F> :<C-U>call SpaceVim#mapping#search#grep("a", "P")<CR>

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
vmap <CR> <Plug>(wildfire-fuel)

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

noremap <C-X> :<C-U>call SwapWord()<CR>

nmap f <Plug>(easymotion-overwin-f)

" function! WindLineRight() abort() abort
"
" endfunction
"
"

function! SwapWord() abort
  if ! exists('g:swap_word_skip')
    let g:swap_word_skip = 1
  endif
  let l:first = expand("<cWORD>")
  let l:save_register_a = @a
  execute "normal! ma"
  let l:cnt = 0
  while l:cnt < g:swap_word_skip
  execute "normal! w"
    let l:cnt = l:cnt + 1
  endwhile
  let l:second = expand("<cWORD>")
  let l:save_register_quote = @"
  let @" = l:first
  execute "normal! viwp"
  let l:cnt = 0
  while l:cnt < g:swap_word_skip
    execute "normal! ge"
    let l:cnt = l:cnt + 1
  endwhile
  let @" = l:second
  execute "normal! viwp`a"
  let @" = l:save_register_quote
  let  @a = l:save_register_a
endfunction

unlet s:m s:insert_mode_mappings s:normal_mode_mappings

if has('win32') || has('win64')
  call dein#add('tbodt/deoplete-tabnine', { 'build': 'powershell.exe .\install.ps1' })
else
  call dein#add('tbodt/deoplete-tabnine', { 'build': './install.sh' })
endif

" call deoplete#custom#var('tabnine', {
" \ 'line_limit': 500,
" \ 'max_num_results': 5,
" \ })

let g:go_autodetect_gopath = 1


" Use K to show documentation in preview window
nnoremap K  :<C-U>call <SID>show_documentation()<CR>

function! s:show_documentation()
   if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  else
    call CocAction('doHover')
  endif
endfunction

" Remap keys for gotos
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)





function! FormatMarkDown() abort
  if &filetype != 'markdown'
    return
  endif
  let l:save_register = @a
  execute "silent w"
  execute "normal! ma"
  execute "%!prettier %"
  execute "normal! `a"
  let @a = l:save_register
endfunction

command! FormatMarkDown call FormatMarkDown()


function! GetColumn() abort
  let l:cols = split(getline("."),'|')
  let l:temp = ""
  for i in l:cols
    let l:temp = l:temp . "\n" . l:i
  endfor
  let @" = l:temp
endfunction

let g:ctrlp_cmdpalette_execute = 1
nnoremap <C-T> :<C-U>call GetColumn()<CR>
nnoremap <Space><Space> :<C-U>CtrlPCmdPalette<CR>
nnoremap <Leader><Space> :<C-U>CtrlPCmdPalette<CR>


function! ChangScroll() abort
  if &buftype == 'terminal'
    setlocal scrolloff=0
  else
    setlocal scrolloff=999
  endif
endfunction

autocmd BufEnter,BufWinEnter,BufCreate,TermOpen,TermLeave *  call ChangScroll()
" autocmd TermOpen,TermEnter * setlocal scrolloff=0
" autocmd TermLeave * setlocal scrolloff=999


" 使用anoconda环境中的python
" 获取符号链接的绝对地址
let s:default_python = system("where python | head -n 1 | xargs greadlink -nf")
if s:default_python =~ "python3"
  let g:python3_host_prog = s:default_python
else
  let g:python_host_prog = s:default_python
endif


vmap <C-J> <Plug>(coc-snippets-select)
imap <C-J> <Plug>(coc-snippets-expand-jump)


" Use <C-j> for jump to next placeholder, it's default of coc.nvim
let g:coc_snippet_next = '<c-j>'

" Use <C-k> for jump to previous placeholder, it's default of coc.nvim
let g:coc_snippet_prev = '<c-k>'

if filereadable(getcwd() . "/.env.vim")
  let g:local_config = getcwd() . "/.env.vim"
  let g:local_config_exists = filereadable(getcwd() . "/.env.vim")
  exe 'source' getcwd() . '/.env.vim'
endif
