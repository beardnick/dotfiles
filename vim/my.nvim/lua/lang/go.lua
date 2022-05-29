-- most codes are copied from https://github.com/edolphin-ydf/goimpl.nvim
local M = {}

local actions = require 'telescope.actions'
local state = require 'telescope.actions.state'
local actions_set = require 'telescope.actions.set'
local conf = require 'telescope.config'.values
local finders = require 'telescope.finders'
local pickers = require 'telescope.pickers'
local ts_utils = require 'nvim-treesitter.ts_utils'

local function lsp_kind_of(kind_name)
    local kind =
    {
        File = 1,
        Module = 2,
        Namespace = 3,
        Package = 4,
        Class = 5,
        Method = 6,
        Property = 7,
        Field = 8,
        Constructor = 9,
        Enum = 10,
        Interface = 11,
        Function = 12,
        Variable = 13,
        Constant = 14,
        String = 15,
        Number = 16,
        Boolean = 17,
        Array = 18,
        Object = 19,
        Key = 20,
        Null = 21,
        EnumMember = 22,
        Struct = 23,
        Event = 24,
        Operator = 25,
        TypeParameter = 26,
    }
    return kind[kind_name]
end

--[
--  {
--    "location": {
--      "uri": "file:///usr/lib/go/src/strings/reader.go",
--      "range": {
--        "end": {
--          "character": 11,
--          "line": 16
--        },
--        "start": {
--          "character": 5,
--          "line": 16
--        }
--      }
--    },
--    "source": "23f41660-109b-459f-b9d5-3d4101709777",
--    "kind": 23,
--    "containerName": "strings",
--    "name": "Reader"
--  }
--]
function M.workspace_symbol(symbol, kind)
    local k = lsp_kind_of(kind)
    local symbols = vim.fn.CocAction('getWorkspaceSymbols', symbol)
    local results = {}
    for index, value in ipairs(symbols) do
        --print(value.containerName,value.kind,value.name)
        if value.kind ~= k then
            goto continue
        end
        results[#results + 1] = value
        ::continue::
    end
    return results
end

local function handle_job_data(data)
    if not data then
        return nil
    end
    -- Because the nvim.stdout's data will have an extra empty line at end on some OS (e.g. maxOS), we should remove it.
    if data[#data] == '' then
        table.remove(data, #data)
    end
    if #data < 1 then
        return nil
    end
    return data
end

local function goimpl(tsnode, packageName, interface)
    local rec2 = ts_utils.get_node_text(tsnode)[1]
    local rec1 = string.lower(string.sub(rec2, 1, 1))

    -- get the package source directory
    local dirname = vim.fn.fnameescape(vim.fn.expand('%:p:h'))

    local setup = 'impl' .. ' -dir ' .. dirname .. " '" .. rec1 .. " *" .. rec2 .. "' " .. packageName .. '.' .. interface
    local data = vim.fn.systemlist(setup)

    data = handle_job_data(data)
    if not data or #data == 0 then
        return
    end

    -- if not found the '$packageName.$interface' type, then try without the packageName
    -- this works when in a main package, it's containerName will return the directory name which the interface file exist in.
    if string.find(data[1], "unrecognized interface:") or string.find(data[1], "couldn't find") then
        setup = 'impl' .. ' -dir ' .. dirname .. " '" .. rec1 .. " *" .. rec2 .. "' " .. interface
        data = vim.fn.systemlist(setup)

        data = handle_job_data(data)
        if not data or #data == 0 then
            return
        end
    end

    local _, _, pos, _ = tsnode:parent():parent():range()
    pos = pos + 1
    vim.fn.append(pos, "") -- insert an empty line
    pos = pos + 1
    vim.fn.append(pos, data)
end

M.goimpl = function(opts)
    opts = opts or {}

    -- use treesitter to detect cursor syntax type
    local tsnode = ts_utils.get_node_at_cursor()
    if tsnode:type() ~= 'type_identifier' or tsnode:parent():type() ~= 'type_spec'
        or tsnode:parent():parent():type() ~= 'type_declaration' then
        print("No type identifier found under cursor")
        return
    end

    local typeNode = tsnode:parent():parent():child(1):child(0)

    pickers.new(opts, {
        prompt_title = "Go Impl",
        finder = finders.new_dynamic {
            entry_maker = function(line)
                return {
                    valid = line ~= nil,
                    value = line,
                    ordinal = line.name, -- used for sorting
                    display = line.containerName .. "." .. line.name, -- used for display list
                }
            end,
            fn = function(prompt)
                return M.workspace_symbol(prompt, 'Interface')
            end,
        },
        sorter = conf.generic_sorter(),
        attach_mappings = function(prompt_bufnr)
            actions_set.select:replace(function(_, type)
                local entry = state.get_selected_entry()
                actions.close(prompt_bufnr)
                if not entry then
                    return
                end

                goimpl(typeNode, entry.value.containerName, entry.value.name)
            end)
            return true
        end,
    }):find()
end

return M
