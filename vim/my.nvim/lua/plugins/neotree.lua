--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setupNeoTree, map, mapopt
local plug = require("plug")
function setupNeoTree()
    local neo_tree = require("neo-tree")
    neo_tree.setup({window = {mapping_options = {noremap = true, nowait = true}, mappings = {l = {[1] = "toggle_node", nowait = false}, h = {[1] = "toggle_node", nowait = false}}}})
    map("n", "<leader>ft", "<cmd>Neotree toggle<cr>", mapopt)
end
map = vim.keymap.set
mapopt = {noremap = true, silent = true}
if plug.loaded("neo-tree.nvim") then
    setupNeoTree()
end
return ____exports
