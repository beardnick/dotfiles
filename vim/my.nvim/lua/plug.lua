local M = {}

---Check whether a plugin has been installed in the configured plugin directory.
---@param plugin_name string
---@return boolean
function M.loaded(plugin_name)
    if not vim.g.pluginDir or not plugin_name then
        return false
    end
    local target = tostring(vim.g.pluginDir) .. "/" .. plugin_name
    for _, path in ipairs(vim.api.nvim_list_runtime_paths()) do
        if path == target then
            return true
        end
    end
    return false
end

return M
