local ts_utils = require 'nvim-treesitter.ts_utils'
local string = require 'collection.string'
local toggleterm = require 'toggleterm'
local Terminal = require 'toggleterm.terminal'.Terminal
local xvim = require'xvim'

local M = {}

local term = Terminal:new({})

function M.cursor_cmd()
    local node = ts_utils.get_node_at_cursor()
    local parent = node
    local top_level = node
    while parent ~= nil do
        local p = parent:parent()
        if p ~= nil and p:type() == 'program' then
            top_level = parent
            break
        end
        parent = p
    end
    local start_row, start_col, end_row, end_col = top_level:range()
    local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    return string.join(text, "\n")
end

function M.send_cursor_cmd()
    local cur = vim.api.nvim_get_current_win()
    local cmd = M.cursor_cmd()
    if not term:is_open() then
        term:open(vim.o.columns * 0.4,'vertical')
    end
    vim.api.nvim_set_current_win(term.window)
    term:send(cmd,false)
    vim.cmd("normal! G")
    vim.api.nvim_set_current_win(cur)
    vim.cmd("stopinsert")
    --toggleterm.exec(cmd)
end

function M.send_lines()
    local cur = vim.api.nvim_get_current_win()
    local cmd = xvim.visual_selection_text()
    if not term:is_open() then
        term:open(vim.o.columns * 0.4,'vertical')
    end
    vim.api.nvim_set_current_win(term.window)
    term:send(cmd,false)
    vim.cmd("normal! G")
    vim.api.nvim_set_current_win(cur)
    vim.cmd("stopinsert")
end

return M
