let g:vim_markdown_math = 1
let g:vim_markdown_toc_autofit = 1

augroup conceal_filetype
    autocmd!
    autocmd FileType markdown,json setlocal concealcursor=c
augroup END


let g:vim_markdown_fenced_languages = [
  \ 'c++=cpp',
  \ 'viml=vim',
  \ 'bash=sh',
  \ 'ini=dosini',
  \ 'js=javascript',
  \ 'json=javascript',
  \ 'jsx=javascriptreact',
  \ 'tsx=typescriptreact',
  \ 'docker=Dockerfile',
  \ 'makefile=make',
  \ 'py=python'
  \ ]


