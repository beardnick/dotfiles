let mapleader = " "

function s:VVSCodeCall(cmd) abort
    let startLine = line("v")
    let endLine = line(".")
    call VSCodeNotifyRange(a:cmd, startLine, endLine, 1)
endfunction

" 设置leader为空格
let mapleader = "\<Space>"

nnoremap <Leader><Leader> :<C-u>call VSCodeCall("workbench.action.showCommands")<CR>

nnoremap <LEADER>; :<C-U>call VSCodeCall("editor.action.commentLine")<CR>
vnoremap <LEADER>; :<C-U>call <SID>VVSCodeCall("editor.action.commentLine")<CR>

nnoremap <C-P> :<C-U>call VSCodeCall("workbench.action.quickOpen")<CR>
"nnoremap <C-L> :<C-U>call VSCodeCall("workbench.action.quickOpen")<CR>

" file
nnoremap <silent><LEADER>fs :<C-U>call VSCodeCall("workbench.action.quickOpen")<CR>
nnoremap <silent><LEADER>ft :<C-U>call VSCodeCall("workbench.files.action.focusFilesExplorer")<CR>



" tag
nnoremap <LEADER>tb :<C-U>call VSCodeCall("outline.focus")<CR>


" search
"nnoremap <Leader>sw :<C-U>Rg <C-R><C-W><CR>
nnoremap <Leader>sr :<C-U>call VSCodeCall("workbench.action.findInFiles")<CR>
"nnoremap <Leader>sf :<C-U>call VSCodeCall("workbench.action.quickOpen")<CR>

nnoremap K :<C-U>call VSCodeCall("editor.action.showHover")<CR>

let g:plugin_dir=expand('$HOME/.config/mynvim')

let g:plug_retries=5
call plug#begin(g:plugin_dir)

    Plug 'rcarriga/nvim-notify'
    Plug 'unblevable/quick-scope'
    Plug 'folke/flash.nvim', {'branch': 'main'}
    Plug 'tpope/vim-surround'

call plug#end()

execute 'luafile' fnamemodify(expand('<sfile>'), ':h').'/init.lua'

