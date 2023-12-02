" @param p plug name
" @return whether p plug is installed
function! myplug#Loaded(p)
    return isdirectory(g:pluginDir . '/' . a:p)
endfunction
