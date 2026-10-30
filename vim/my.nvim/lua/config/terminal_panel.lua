local M = {}

local PANEL_HEIGHT_PERCENT = 30
local SIDEBAR_FILETYPE = "terminal_mate_sidebar"
local TOGGLE_KEYS = { "<F7>", "<C-`>" }

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
    require("terminal_mate").new_terminal()
    focus_terminal()
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

    vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("MynvimTerminalPanel", { clear = true }),
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
