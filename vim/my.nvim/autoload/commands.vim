function! commands#UninstallPackages() abort
	call map(dein#check_clean(), "delete(v:val, 'rf')")
	call dein#recache_runtimepath()
endfunction


function! commands#BufferSplitVertical() abort
    let l:this_buf = bufnr()
    execute 'wincmd k'
    let l:upper_buf = bufnr()
    if l:this_buf !=# l:upper_buf
        execute 'wincmd v'
        if buffer_exists(l:this_buf)
            execute 'buffer ' . l:this_buf
            execute 'wincmd j | q'
        endif
    endif
endfunction
