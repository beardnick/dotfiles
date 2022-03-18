local M = {}

function M.loaded (p)
    if vim.g.plugs == nil then
        print('vim-plug not installed no g:plugs')
        return
    end
    return require('collection.table').has_key(vim.g.plugs,p)
end

return M
