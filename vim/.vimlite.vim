" 不加载.config/nvim中的内容
set rtp-=~/.config/nvim
set rtp-=~/.config/nvim/after

let mapleader = " "

set statusline=%F\ >\ %y
set number
set nowrap

" 使光标始终在屏幕中间
set sidescrolloff=999
set scrolloff=999


" 更快地复制粘帖到系统粘贴板上
noremap <leader>yy "+y
noremap <leader>pp "+p

noremap <Leader>w <C-W>

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
nnoremap <Leader>ft :<C-U>20Lexplore<CR>

let g:netrw_liststyle= 3
" remap netrw
augroup netrw_mapping
    autocmd!
    autocmd filetype netrw call NetrwMapping()
augroup END

function! NetrwMapping()
    nmap <buffer> h <Plug>NetrwBrowseUpDir
    nmap <buffer> l <Plug>NetrwLocalBrowseCheck
endfunction


nnoremap <silent><C-L> :<C-U>nohlsearch<CR>
inoremap jk <ESC>
inoremap jj <ESC>
inoremap kk <ESC>
vnoremap < <gv
vnoremap > >gv

" 复制粘贴
nnoremap <Leader>yy viw"+y
nnoremap <Leader>ya viw"ay
nnoremap <Leader>yb viw"by
nnoremap <Leader>yc viw"cy

vnoremap <Leader>yy "+y
vnoremap <Leader>ya "ay
vnoremap <Leader>yb "by
vnoremap <Leader>yc "cy

nnoremap <Leader>pp viw"+p
nnoremap <Leader>pa viw"ap
nnoremap <Leader>pb viw"bp
nnoremap <Leader>pc viw"cp

vnoremap <Leader>pp "+p
vnoremap <Leader>pa "ap
vnoremap <Leader>pb "bp
vnoremap <Leader>pc "cp

vnoremap <Leader>rr "+p
vnoremap <Leader>ra "ap
vnoremap <Leader>rb "bp
vnoremap <Leader>rc "cp

nnoremap <Leader>rr viw"+p
nnoremap <Leader>ra viw"ap
nnoremap <Leader>rb viw"bp
nnoremap <Leader>rc viw"cp

nnoremap <M-.> :<C-U>5wincmd ><CR>
nnoremap <M-,> :<C-U>5wincmd <<CR>
nnoremap <M-=> :<C-U>5wincmd +<CR>
nnoremap <M--> :<C-U>5wincmd -<CR>

nmap <LEADER>bn :<C-U>bnext<CR>
nmap <LEADER>bp :<C-U>bprevious<CR>
nmap <LEADER>bd :<C-U>bdelete<CR>
nmap <LEADER>bl :<C-U>blast<CR>


" 简单的补全
let g:apc_enable_ft = get(g:, 'apc_enable_ft', {})    " enable filetypes
let g:apc_enable_tab = get(g:, 'apc_enable_tab', 1)   " remap tab
let g:apc_min_length = get(g:, 'apc_min_length', 2)   " minimal length to open popup
let g:apc_key_ignore = get(g:, 'apc_key_ignore', [])  " ignore keywords
let g:apc_bs_close = get(g:, 'apc_bs_close', 1)       " enable <BS> close

" get word before cursor
function! s:get_context()
	return strpart(getline('.'), 0, col('.') - 1)
endfunc

function! s:meets_keyword(context)
	if g:apc_min_length <= 0
		return 0
	endif
	let matches = matchlist(a:context, '\(\k\{' . g:apc_min_length . ',}\)$')
	if empty(matches)
		return 0
	endif
	for ignore in g:apc_key_ignore
		if stridx(ignore, matches[1]) == 0
			return 0
		endif
	endfor
	return 1
endfunc

function! s:check_back_space() abort
	  return col('.') < 2 || getline('.')[col('.') - 2]  =~# '\s'
endfunc

function! s:on_backspace()
	if pumvisible() == 0
		return "\<BS>"
	endif
	let text = matchstr(s:get_context(), '.*\ze.')
	return s:meets_keyword(text)? "\<BS>" : "\<c-e>\<bs>"
endfunc


" autocmd for CursorMovedI
function! s:feed_popup()
	let enable = get(b:, 'apc_enable', 0)
	let lastx = get(b:, 'apc_lastx', -1)
	let lasty = get(b:, 'apc_lasty', -1)
	let tick = get(b:, 'apc_tick', -1)
	if &bt != '' || enable == 0 || &paste
		return -1
	endif
	let x = col('.') - 1
	let y = line('.') - 1
	if pumvisible()
		let context = s:get_context()
		if s:meets_keyword(context) == 0
			call feedkeys("\<c-e>", 'n')
		endif
		let b:apc_lastx = x
		let b:apc_lasty = y
		let b:apc_tick = b:changedtick
		return 0
	elseif lastx == x && lasty == y
		return -2
	elseif b:changedtick == tick
		let lastx = x
		let lasty = y
		return -3
	endif
	let context = s:get_context()
	if s:meets_keyword(context)
		silent! call feedkeys("\<c-n>", 'n')
		let b:apc_lastx = x
		let b:apc_lasty = y
		let b:apc_tick = b:changedtick
	endif
	return 0
endfunc

" autocmd for CompleteDone
function! s:complete_done()
	let b:apc_lastx = col('.') - 1
	let b:apc_lasty = line('.') - 1
	let b:apc_tick = b:changedtick
endfunc

" enable apc
function! s:apc_enable()
	call s:apc_disable()
	augroup ApcEventGroup
		au!
		au CursorMovedI <buffer> nested call s:feed_popup()
		au CompleteDone <buffer> call s:complete_done()
	augroup END
	let b:apc_init_autocmd = 1
	if g:apc_enable_tab
		inoremap <silent><buffer><expr> <tab>
					\ pumvisible()? "\<c-n>" :
					\ <SID>check_back_space() ? "\<tab>" : "\<c-n>"
		inoremap <silent><buffer><expr> <s-tab>
					\ pumvisible()? "\<c-p>" : "\<s-tab>"
		let b:apc_init_tab = 1
	endif
	inoremap <silent><buffer><expr> <bs> <SID>on_backspace()
	let b:apc_init_bs = 1
	let b:apc_save_infer = &infercase
	setlocal infercase
	let b:apc_enable = 1
endfunc

" disable apc
function! s:apc_disable()
	if get(b:, 'apc_init_autocmd', 0)
		augroup ApcEventGroup
			au!
		augroup END
	endif
	if get(b:, 'apc_init_tab', 0)
		silent! iunmap <buffer><expr> <tab>
		silent! iunmap <buffer><expr> <s-tab>
	endif
	if get(b:, 'apc_init_bs', 0)
		silent! iunmap <buffer><expr> <bs>
	endif
	if get(b:, 'apc_save_infer', '') != ''
		let &l:infercase = b:apc_save_infer
	endif
	let b:apc_init_autocmd = 0
	let b:apc_init_tab = 0
	let b:apc_init_bs = 0
	let b:apc_save_infer = ''
	let b:apc_enable = 0
endfunc

" check if need to be enabled
function! s:apc_check_init()
	if &bt == '' && get(g:apc_enable_ft, &ft, 0) != 0
		ApcEnable
	elseif &bt == '' && get(g:apc_enable_ft, '*', 0) != 0
		ApcEnable
	endif
endfunc

" commands & autocmd
command -nargs=0 ApcEnable call s:apc_enable()
command -nargs=0 ApcDisable call s:apc_disable()

augroup ApcInitGroup
	au!
	au FileType * call s:apc_check_init()
augroup END

let g:apc_enable_ft = {'*':1}
set completeopt=menu,menuone,noselect
set cpt=.,k,w,b
