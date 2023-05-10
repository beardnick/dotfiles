local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

function Set(list)
    local set = {}
    for _, l in ipairs(list) do set[l] = true end
    return set
end

M.inspect_cursor_node = function()
    local node = ts_utils.get_node_at_cursor()
    local parent = node
    while parent ~= nil do
        print('parent', parent:type(), parent:symbol())
        parent = parent:parent()
    end
    local next = node
    while next ~= nil do
        print('next', next:type())
        next = next:next_sibling()
    end
    local prev = node
    while prev ~= nil do
        print('prev', prev:type())
        prev = prev:prev_sibling()
    end
end

function M.get_top_for_node(node)
    local parent = node
    local result = node

    while parent ~= nil do
        result = parent
        parent = result:parent()
    end

    return result
end

function M.outter_type(node, ...)
    local types = Set({ ... })
    local parent = node:parent()
    local result = node

    while parent ~= nil do
        result = parent
        --print("outter type",result:type())
        if types[result:type()] then
            return result
        end
        parent = result:parent()
    end

    return result
end

local map = vim.api.nvim_set_keymap
local mapopt = { noremap = true, silent = true }

function M.jump_outter_func()
    vim.cmd([[normal! m']]) -- set jumplist to jump back with <C-i>/<C-o>
    local node = ts_utils.get_node_at_cursor()
    local outter = M.outter_type(node, 'function_declaration','class_declaration','method_definition','field_definition','function_definition')
    local row, column = outter:start()
    vim.fn.cursor(row + 1, column + 1)
    vim.cmd([[normal! m']]) -- set jumplist to jump back with <C-i>/<C-o>

end

map('n', '[[', [[<cmd>lua require'treesitter'.jump_outter_func()<cr>]], mapopt)


return M
