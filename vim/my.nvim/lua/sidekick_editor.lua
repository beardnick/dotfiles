local M = {}
local source_window

local function is_editor(win)
    return vim.api.nvim_win_is_valid(win)
        and vim.api.nvim_win_get_config(win).relative == ""
        and vim.bo[vim.api.nvim_win_get_buf(win)].buftype == ""
end

function M.setup()
    local function remember()
        local win = vim.api.nvim_get_current_win()
        if is_editor(win) then
            source_window = win
        end
    end
    remember()
    vim.api.nvim_create_autocmd("WinEnter", {
        group = vim.api.nvim_create_augroup("SidekickEditorBridge", { clear = true }),
        callback = remember,
    })
end

function M.open(location)
    local path = location.path
    assert(type(path) == "string" and path ~= "", "a file path is required")
    assert(vim.fn.filereadable(path) == 1, "file does not exist: " .. path)
    local line = location.line or 1
    local column = location.column or 1
    assert(type(line) == "number" and line >= 1 and line % 1 == 0, "line must be a positive integer")
    assert(type(column) == "number" and column >= 1 and column % 1 == 0, "column must be a positive integer")

    local win = source_window
    if not win or not is_editor(win) then
        win = nil
        for _, candidate in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
            if is_editor(candidate) then
                win = candidate
                break
            end
        end
    end
    if not win then
        vim.cmd("topleft vnew")
        win = vim.api.nvim_get_current_win()
    end
    vim.api.nvim_win_call(win, function()
        -- No :edit! or forced buffer replacement: unsaved work must stay intact.
        vim.api.nvim_cmd({ cmd = "edit", args = { path } }, {})
        local buf = vim.api.nvim_win_get_buf(win)
        line = math.min(line, vim.api.nvim_buf_line_count(buf))
        local text = vim.api.nvim_buf_get_lines(buf, line - 1, line, false)[1]
        column = math.min(column - 1, math.max(#text - 1, 0))
        vim.api.nvim_win_set_cursor(win, { line, column })
        vim.cmd("normal! zz")
    end)
    vim.cmd.stopinsert()
    vim.api.nvim_set_current_win(win)
    source_window = win
    return { path = vim.api.nvim_buf_get_name(0), line = line, column = column + 1 }
end

function M.codex_tool(args)
    local source = debug.getinfo(1, "S").source:sub(2)
    local helper = vim.fn.fnamemodify(source, ":h:h") .. "/bin/nvim-open"
    local server = vim.v.servername
    if server == "" then
        server = vim.fn.serverstart()
    end
    local cmd = {
        "codex",
        "-c",
        'mcp_servers.sidekick_editor.command="python3"',
        "-c",
        "mcp_servers.sidekick_editor.args=" .. vim.json.encode({ helper, "--mcp" }),
        "-c",
        'mcp_servers.sidekick_editor.env_vars=["SIDEKICK_NVIM_SERVER","SIDEKICK_NVIM"]',
    }
    vim.list_extend(cmd, args or {})
    return {
        cmd = cmd,
        env = { SIDEKICK_NVIM_SERVER = server, SIDEKICK_NVIM = vim.v.progpath },
    }
end

return M
