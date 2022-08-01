local string = require 'collection.string'

local M = {}

function M.visual_selection_range()
    local _, start_row, start_col, _ = unpack(vim.fn.getpos("'<"))
    local _, end_row, end_col, _ = unpack(vim.fn.getpos("'>"))
    -- end_col == 2147483647 means "after the end of the line" so we  return the end of the line
    -- h getpos
    if end_col == 2147483647 then
        end_col = vim.fn.strlen(vim.fn.getline(end_row))
    end
    start_row = start_row - 1
    start_col = start_col == 0 and start_col or start_col - 1
    end_row = end_row - 1
    --end_col = end_col == 0 and end_col or end_col - 1
    return start_row, start_col,end_row,end_col
end

function M.visual_selection_text()
    local start_row, start_col, end_row, end_col = M.visual_selection_range()
    local text = vim.api.nvim_buf_get_text(0, start_row, start_col, end_row, end_col, {})
    return string.join(text, "\n")
end

-- for debug
function M.inspect_range()
    print('mode', vim.fn.mode())
    print(vim.inspect(vim.fn.getpos("'<")))
    print(vim.inspect(vim.fn.getpos("'>")))
    print(vim.inspect(vim.api.nvim_buf_get_mark(0, "<")))
    print(vim.inspect(vim.api.nvim_buf_get_mark(0, ">")))
end

return M
