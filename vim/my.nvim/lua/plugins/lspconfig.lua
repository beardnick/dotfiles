--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local configCmp, configLsp, setupLsp, map, mapopt
local plug = require("plug")
function configCmp()
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
function configLsp()
    local lspconfig = require("lspconfig")
    local nvim_semantic_tokens = require("nvim-semantic-tokens")
    local highlighters = require("nvim-semantic-tokens.table-highlighter")
    local null_ls = require("null-ls")
    null_ls.setup({sources = {null_ls.builtins.formatting.golines}})
    nvim_semantic_tokens.setup({preset = "default", highlighters = highlighters})
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
            callback = setupLsp
        }
    )
end
function setupLsp()
    vim.lsp.inlay_hint.enable(0, true)
    map("n", "gD", vim.lsp.buf.declaration, mapopt)
    map("n", "gd", vim.lsp.buf.definition, mapopt)
    map("n", "gr", vim.lsp.buf.references, mapopt)
    map("n", "K", vim.lsp.buf.hover, mapopt)
    map("n", "gi", vim.lsp.buf.implementation, mapopt)
    map("n", "<C-k>", vim.lsp.buf.signature_help, mapopt)
    map("n", "<C-\\>", vim.lsp.buf.code_action, mapopt)
    map("n", "<leader>rn", vim.lsp.buf.rename, mapopt)
    map(
        "n",
        "<leader>lf",
        function() return vim.lsp.buf.format({async = true}) end,
        mapopt
    )
end
map = vim.keymap.set
mapopt = {noremap = true, silent = true}
if plug.loaded("nvim-lspconfig") then
    local mason = require("mason")
    local mason_lspconfig = require("mason-lspconfig")
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
    configLsp()
    configCmp()
end
return ____exports
