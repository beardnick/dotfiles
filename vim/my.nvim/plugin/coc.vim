if !myplug#Loaded('coc.nvim')
    finish
endif




autocmd CursorHold * silent call CocActionAsync('highlight')

" C-n C-p vim style completion keymaps
inoremap <silent><expr> <C-n>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()

" tab and shift+tab vscode style completion keymaps
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

" enter to comfirm completion
if exists('*complete_info')
  inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
else
  imap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
endif

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~ '\s'
endfunction

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

autocmd BufWritePre *.go :silent call CocAction('runCommand', 'editor.action.organizeImport')
autocmd BufWritePre *.go :silent call CocAction('format')

command! Refactor call CocActionAsync('refactor')
" will popup a rename dialog
command! Rename call CocActionAsync('rename')
command! -nargs=0 Format :call CocAction('format')
command! -nargs=? Fold :call     CocAction('fold', <f-args>)

nnoremap <silent>K  :<C-U> call CocActionAsync('definitionHover')<CR>
vnoremap <silent>K  :<C-U> call CocActionAsync('definitionHover')<CR>

" scroll float documents
nnoremap <nowait><expr> <C-d> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-d>"
nnoremap <nowait><expr> <C-u> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-u>"
inoremap <nowait><expr> <C-d> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
inoremap <nowait><expr> <C-u> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gr <Plug>(coc-references)
nmap <silent> gi <Plug>(coc-implementation)


nmap <silent> ]c <Plug>(coc-git-nextchunk)
nmap <silent> [c <Plug>(coc-git-prevchunk)
nmap <silent> ]e <Plug>(coc-diagnostic-next-error)
nmap <silent> [e <Plug>(coc-diagnostic-prev-error)
nmap <silent> ]w <Plug>(coc-diagnostic-next)
nmap <silent> [w <Plug>(coc-diagnostic-prev)
