--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local plug = require("plug")
if plug.loaded("mason.nvim") then
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    mason.setup()
    mason_lspconfig.setup({ensure_installed = {"lua_ls", "rust_analyzer", "gopls"}})
end
return ____exports
