local M = {}

function M.loaded (p)
    if vim.g.plugs == nil then
        print('vim-plug not installed no g:plugs')
        return
    end
    for key, value in pairs(vim.g.plugs) do
        if key ~= p then
            goto continue
        end
        if vim.fn.isdirectory(value.dir) == 1  then
            return true;
        end
        ::continue::
    end
    return false
end

return M
