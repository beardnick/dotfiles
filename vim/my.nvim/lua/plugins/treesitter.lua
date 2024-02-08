--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setupTreesitter
local plug = require("plug")
function setupTreesitter()
    local treesitter_config = require("nvim-treesitter.configs")
    treesitter_config.setup({ensure_installed = {
        "go",
        "c",
        "cpp",
        "rust",
        "java",
        "javascript",
        "typescript",
        "lua"
    }, sync_install = false, highlight = {enable = true, additional_vim_regex_highlighting = false}, playground = {
        enable = true,
        disable = {},
        updatetime = 25,
        persist_queries = false,
        keybindings = {
            toggle_query_editor = "o",
            toggle_hl_groups = "i",
            toggle_injected_languages = "t",
            toggle_anonymous_nodes = "a",
            toggle_language_display = "I",
            focus_language = "f",
            unfocus_language = "F",
            update = "R",
            goto_node = "<cr>",
            show_help = "?"
        }
    }})
    vim.o.foldmethod = "expr"
    vim.o.foldexpr = "nvim_treesitter#foldexpr()"
    vim.o.foldlevelstart = 99
end
local map = vim.keymap.set
local mapopt = {noremap = true, silent = true}
if plug.loaded("nvim-treesitter") then
    setupTreesitter()
end
return ____exports
