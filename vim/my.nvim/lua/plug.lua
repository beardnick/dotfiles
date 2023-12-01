--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
function ____exports.loaded(p)
    if not vim.g.plugs then
        vim.notify("vim-plug not installed no g:plugs")
        return false
    end
    local ____opt_0 = vim.g.plugs[p]
    if ____opt_0 ~= nil then
        ____opt_0 = ____opt_0.dir
    end
    local dir = ____opt_0
    if not dir then
        return false
    end
    return vim.fn.isdirectory(dir) == 1
end
return ____exports
