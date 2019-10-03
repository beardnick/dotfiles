let g:mapleader = ','
let g:spacevim_autocomplete_method = "coc"

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

let g:go_doc_keywordprg_enabled = 0
let g:go_def_mapping_enabled = 0
let g:go_autodetect_gopath = 1
let g:jedi#documentation_command = ''

set guifont=HackNerdFontComplete-Bold-Italic:h11
let g:coc_node_path = '/usr/local/opt/node@10/bin/node'
