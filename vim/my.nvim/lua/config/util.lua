local M = {}

local function normalize(path)
    return vim.fn.fnamemodify(path, ":p")
end

function M.dofile_if_readable(path)
    if not path or vim.fn.filereadable(path) ~= 1 then
        return false
    end
    dofile(normalize(path))
    return true
end

function M.load_dir(root, relative)
    local dir = normalize(root .. "/" .. relative)
    local files = vim.fn.globpath(dir, "**/*.lua", false, true)

    table.sort(files)
    for _, path in ipairs(files) do
        dofile(path)
    end
end

return M
