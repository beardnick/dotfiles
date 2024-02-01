--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setupLsp, onLspAttach, setupCmp, setupNullLs, setupLspUtils, map, mapopt
local plug = require("plug")
function setupLsp()
    local lspconfig = require("lspconfig")
    local nvim_semantic_tokens = require("nvim-semantic-tokens")
    local highlighters = require("nvim-semantic-tokens.table-highlighter")
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
    local fidget = require("fidget")
    fidget.setup()
    mason.setup()
    mason_lspconfig.setup({ensure_installed = {
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "zls",
        "typescript-language-server",
        "vim-language-server",
        "bash-language-server"
    }})
    nvim_semantic_tokens.setup({preset = "default", highlighters = highlighters})
    lspconfig.lua_ls.setup({})
    lspconfig.tsserver.setup({})
    lspconfig.gopls.setup({settings = {gopls = {hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true
    }, semanticTokens = true}}})
    map("n", "]e", vim.diagnostic.goto_next, mapopt)
    map("n", "[e", vim.diagnostic.goto_prev, mapopt)
    map("n", "<leader>e", vim.diagnostic.open_float, mapopt)
    vim.api.nvim_create_autocmd(
        "LspAttach",
        {
            group = vim.api.nvim_create_augroup("UserLspConfig", {}),
            callback = onLspAttach
        }
    )
end
function onLspAttach()
    vim.lsp.inlay_hint.enable(0, true)
    map("n", "gD", vim.lsp.buf.declaration, mapopt)
    map("n", "gd", vim.lsp.buf.definition, mapopt)
    map("n", "gr", vim.lsp.buf.references, mapopt)
    map("n", "K", vim.lsp.buf.hover, mapopt)
    map("n", "gi", vim.lsp.buf.implementation, mapopt)
    map("n", "<C-k>", vim.lsp.buf.signature_help, mapopt)
    map("n", "<C-\\>", vim.lsp.buf.code_action, mapopt)
    map(
        "n",
        "<leader>lf",
        function() return vim.lsp.buf.format({async = true}) end,
        mapopt
    )
end
function setupCmp()
    local cmp = require("cmp")
    local lsp_signature = require("lsp_signature")
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ["<C-Space:"] = cmp.mapping.complete(),
            ["<C-e>"] = cmp.mapping.abort(),
            ["<CR>"] = cmp.mapping.confirm({select = true})
        }),
        sources = cmp.config.sources({{name = "nvim_lsp"}, {name = "buffer"}, {name = "path"}})
    })
    lsp_signature.setup({})
    cmp.setup.cmdline(
        "/",
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = {{name = "buffer"}}
        }
    )
    cmp.setup.cmdline(
        ":",
        {
            mapping = cmp.mapping.preset.cmdline(),
            sources = cmp.config.sources({{name = "path"}, {name = "cmdline", option = {ignore_cmds = {"Man", "!"}}}})
        }
    )
end
function setupNullLs()
    local null_ls = require("null-ls")
    null_ls.setup({sources = {null_ls.builtins.formatting.golines}})
end
function setupLspUtils()
    local lsp_locations = require("lsputil.locations")
    local lsp_symbols = require("lsputil.symbols")
    vim.lsp.handlers["textDocument/references"] = lsp_locations.references_handler
    vim.lsp.handlers["textDocument/definition"] = lsp_locations.definition_handler
    vim.lsp.handlers["textDocument/declaration"] = lsp_locations.declaration_handler
    vim.lsp.handlers["textDocument/typeDefinition"] = lsp_locations.typeDefinition_handler
    vim.lsp.handlers["textDocument/implementation"] = lsp_locations.implementation_handler
    vim.lsp.handlers["textDocument/documentSymbol"] = lsp_symbols.document_handler
    vim.lsp.handlers["workspace/symbol"] = lsp_symbols.workspace_handler
    vim.g.lsp_utils_location_opts = {mode = "editor"}
end
map = vim.keymap.set
mapopt = {noremap = true, silent = true}
if plug.loaded("nvim-lspconfig") then
    setupLsp()
end
if plug.loaded("none-ls.nvim") then
    setupNullLs()
end
if plug.loaded("nvim-cmp") then
    setupCmp()
end
if plug.loaded("nvim-lsputils") then
    setupLspUtils()
end
if plug.loaded("renamer.nvim") then
    local renamer = require("renamer")
    renamer.setup()
    map("n", "<leader>rn", renamer.rename, mapopt)
end
return ____exports
