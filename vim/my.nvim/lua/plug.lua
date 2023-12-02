local ____lualib = require("lualib_bundle")
local __TS__ArrayIndexOf = ____lualib.__TS__ArrayIndexOf
local ____exports = {}
function ____exports.loaded(p)
    return __TS__ArrayIndexOf(
        vim.api.nvim_list_runtime_paths(),
        (tostring(vim.g.pluginDir) .. "/") .. p
    ) ~= -1
end
return ____exports
