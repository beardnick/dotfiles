local ts_utils = require 'nvim-treesitter.ts_utils'

local M = {}

M.inspect_cursor_node = function ()
    local node = ts_utils.get_node_at_cursor()
    local parent = node
    while parent ~= nil  do
        print('parent',parent:type())
        parent = parent:parent()
    end
    local next = node
    while next ~= nil  do
        print('next',next:type())
        next = next:next_sibling()
    end
    local prev = node
    while prev ~= nil  do
        print('prev',prev:type())
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

return M
