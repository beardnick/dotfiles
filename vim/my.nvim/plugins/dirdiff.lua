if not require('plug').loaded('vim-dirdiff') then
    return
end

vim.g.DirDiffExcludes = "CVS,*.class,*.o,.git"

