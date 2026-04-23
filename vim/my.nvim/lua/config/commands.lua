local M = {}

local function notify_missing(message)
    vim.notify(message, vim.log.levels.WARN)
end

function M.source_current_file()
    local path = vim.api.nvim_buf_get_name(0)

    if path == "" then
        return
    end

    if path:match("%.lua$") then
        dofile(path)
        return
    end

    vim.cmd.source(vim.fn.fnameescape(path))
end

function M.buffer_split_vertical()
    local this_buf = vim.api.nvim_get_current_buf()

    vim.cmd("wincmd k")
    local upper_buf = vim.api.nvim_get_current_buf()
    if this_buf == upper_buf then
        return
    end

    vim.cmd("wincmd v")
    if not vim.api.nvim_buf_is_valid(this_buf) then
        return
    end

    vim.api.nvim_set_current_buf(this_buf)
    vim.cmd("wincmd j")
    vim.cmd("close")
end

function M.toggle_background()
    vim.o.background = vim.o.background == "dark" and "light" or "dark"
end

function M.toggle_recording()
    if vim.fn.reg_recording() ~= "" then
        vim.cmd("normal q")
        return
    end

    vim.cmd("normal qq")
end

function M.load_project_local_configs()
    local config_dir = vim.fn.getcwd() .. "/.vim"
    local files = vim.fn.globpath(config_dir, "*.lua", false, true)

    table.sort(files)
    for _, path in ipairs(files) do
        dofile(path)
    end
end

function M.float_tool(cmd)
    local open = vim.fn["floaterm#terminal#open"]
    local add = vim.fn["floaterm#buflist#add"]

    if type(open) ~= "function" or type(add) ~= "function" then
        notify_missing("floaterm is not available")
        return
    end

    local ok, bufnr = pcall(open, -1, cmd, {}, {})
    if not ok then
        notify_missing("failed to open floaterm")
        return
    end

    pcall(add, bufnr)
end

return M
