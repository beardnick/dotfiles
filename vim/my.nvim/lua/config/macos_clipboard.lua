local M = {}

local function copy(lines)
    -- A nested terminal's OSC52 copy can arrive as one item containing \n.
    -- Sending a list through the default provider turns those newlines into
    -- NUL bytes. Raw string stdin preserves both ordinary and embedded lines.
    local result = vim.system({ "pbcopy" }, { stdin = table.concat(lines, "\n") }):wait()
    if result.code ~= 0 then
        vim.notify("Failed to copy to the macOS clipboard", vim.log.levels.ERROR)
    end
end

function M.setup()
    if vim.fn.has("mac") ~= 1 or vim.g.clipboard ~= nil then
        return false
    end
    if vim.fn.executable("pbcopy") ~= 1 or vim.fn.executable("pbpaste") ~= 1 then
        return false
    end
    vim.g.clipboard = {
        name = "pbcopy",
        copy = { ["+"] = copy, ["*"] = copy },
        paste = { ["+"] = { "pbpaste" }, ["*"] = { "pbpaste" } },
        cache_enabled = 0,
    }
    -- Other plugin setup may already have initialized the default provider.
    vim.fn["provider#clipboard#Executable"]()
    return true
end

return M
