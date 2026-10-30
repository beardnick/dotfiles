local M = {}

local PANEL_HEIGHT_PERCENT = 30
local SIDEBAR_FILETYPE = "terminal_mate_sidebar"
local TOGGLE_KEYS = { "<F7>", "<C-`>" }
local DIRECT_TERMINAL_COUNT = 9

local function forward_remote_key(key)
    if not vim.b.mynvim_remote_ui then
        return false
    end
    -- These commands run in the outer client's Normal mode. Re-enter its
    -- terminal and send the key without applying the outer mappings again.
    local input = vim.api.nvim_replace_termcodes("i" .. key, true, false, true)
    vim.api.nvim_feedkeys(input, "n", false)
    return true
end

-- remote-nvim's supported client_callback calls this after creating its UI.
-- Buffer-local identity maps pass the original key into the remote UI process
-- rather than letting our global terminal-mode maps open a local shell.
function M.attach_remote_client(buf)
    vim.b[buf].mynvim_remote_ui = true
    local keys = vim.list_extend(vim.deepcopy(TOGGLE_KEYS), { "<F8>", "<C-n>", "<C-p>", "<C-\\><C-n>" })
    for id = 1, DIRECT_TERMINAL_COUNT do
        table.insert(keys, ("<M-%d>"):format(id))
    end
    for _, key in ipairs(keys) do
        vim.keymap.set("t", key, key, {
            buffer = buf,
            remap = false,
            desc = "Forward terminal panel key to remote Neovim",
        })
    end
end

local function focus_terminal()
    local win = require("terminal_mate").get_state().terminal_win
    if not win or not vim.api.nvim_win_is_valid(win) then
        return
    end
    if vim.bo[vim.api.nvim_win_get_buf(win)].buftype ~= "terminal" then
        return
    end
    vim.api.nvim_set_current_win(win)
    vim.cmd.startinsert()
end

function M.toggle()
    if forward_remote_key("<F7>") then
        return
    end
    local terminal = require("terminal_mate")
    local win = terminal.get_state().terminal_win
    if win and vim.api.nvim_win_is_valid(win)
        and vim.api.nvim_win_get_tabpage(win) == vim.api.nvim_get_current_tabpage() then
        terminal.hide()
        return
    end
    terminal.open_pane()
    focus_terminal()
end

function M.new_terminal()
    if forward_remote_key("<F8>") then
        return
    end
    require("terminal_mate").new_terminal()
    focus_terminal()
end

function M.next_terminal()
    require("terminal_mate").next_terminal()
    focus_terminal()
end

function M.prev_terminal()
    require("terminal_mate").prev_terminal()
    focus_terminal()
end

function M.switch_terminal(id)
    require("terminal_mate").switch_terminal(id)
    focus_terminal()
end

local function attach_switch_keys(buf)
    if not vim.b[buf].terminal_mate_managed then
        return
    end
    local options = { buffer = buf, silent = true }
    -- Protect the built-in escape sequence from the standalone Ctrl+N map.
    vim.keymap.set("t", "<C-\\><C-n>", "<C-\\><C-n>",
        vim.tbl_extend("force", options, { desc = "Leave terminal input mode" }))
    local prefix = "<C-\\><C-n><Cmd>lua require('config.terminal_panel')."
    vim.keymap.set("t", "<C-n>", prefix .. "next_terminal()<CR>",
        vim.tbl_extend("force", options, { desc = "Next terminal instance" }))
    vim.keymap.set("t", "<C-p>", prefix .. "prev_terminal()<CR>",
        vim.tbl_extend("force", options, { desc = "Previous terminal instance" }))
    for id = 1, DIRECT_TERMINAL_COUNT do
        vim.keymap.set("t", ("<M-%d>"):format(id), prefix .. ("switch_terminal(%d)<CR>"):format(id),
            vim.tbl_extend("force", options, { desc = ("Select terminal #%d"):format(id) }))
    end
end

function M.setup()
    require("terminal_mate").setup({
        backend = "nvim",
        layout = "split",
        split_percent = PANEL_HEIGHT_PERCENT,
    })

    vim.api.nvim_create_user_command("TerminalPanelToggle", M.toggle, {
        desc = "Toggle terminal panel without stopping the shell",
    })
    vim.api.nvim_create_user_command("TerminalPanelNew", M.new_terminal, {
        desc = "Create and focus a terminal in the panel",
    })

    -- F7 works without extended keyboard support; Ctrl+backtick is an alias
    -- for terminal apps/GUI clients that can distinguish that key combination.
    for _, key in ipairs(TOGGLE_KEYS) do
        vim.keymap.set({ "n", "i" }, key, "<Cmd>TerminalPanelToggle<CR>", {
            desc = "Toggle terminal panel",
        })
        vim.keymap.set("t", key, "<C-\\><C-n><Cmd>TerminalPanelToggle<CR>", {
            desc = "Toggle terminal panel",
        })
    end
    vim.keymap.set({ "n", "i" }, "<F8>", "<Cmd>TerminalPanelNew<CR>", {
        desc = "Create terminal in panel",
    })
    vim.keymap.set("t", "<F8>", "<C-\\><C-n><Cmd>TerminalPanelNew<CR>", {
        desc = "Create terminal in panel",
    })
    vim.keymap.set("n", "<leader>tn", M.new_terminal, { desc = "Create terminal in panel" })

    local group = vim.api.nvim_create_augroup("MynvimTerminalPanel", { clear = true })
    -- TerminalMate marks the buffer after TermOpen; TermEnter sees that marker
    -- and also covers restored shells when they are entered for the first time.
    vim.api.nvim_create_autocmd("TermEnter", {
        group = group,
        callback = function(event) attach_switch_keys(event.buf) end,
    })
    for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        attach_switch_keys(buf)
    end

    vim.api.nvim_create_autocmd("FileType", {
        group = group,
        pattern = SIDEBAR_FILETYPE,
        callback = function(event)
            vim.keymap.set("n", "n", M.new_terminal, { buffer = event.buf, desc = "Create terminal" })
            vim.keymap.set("n", "+", M.new_terminal, { buffer = event.buf, desc = "Create terminal" })
            vim.keymap.set("n", "q", function() require("terminal_mate").hide() end, {
                buffer = event.buf,
                desc = "Hide terminal panel",
            })
        end,
    })
end

return M
