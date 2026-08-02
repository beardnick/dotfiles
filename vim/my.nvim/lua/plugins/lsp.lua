local plug = require("plug")

if not (plug.loaded("nvim-lspconfig") and plug.loaded("mason.nvim") and plug.loaded("mason-lspconfig.nvim")) then
    return
end

local api = vim.api
local servers = require("lsp.servers")
local keymaps = require("lsp.keymaps")
local format = require("lsp.format")

if plug.loaded("lazydev.nvim") then
    require("lazydev").setup()
end

require("mason").setup()
require("mason-lspconfig").setup({
    ensure_installed = servers.ensure_installed,
})

if plug.loaded("mason-tool-installer.nvim") then
    require("mason-tool-installer").setup({
        ensure_installed = servers.ensure_tools,
    })
end

if plug.loaded("blink.cmp") then
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })
end

for name, config in pairs(servers.config) do
    vim.lsp.config(name, config)
end

-- mason-lspconfig only auto-enables servers it installed; enable the whole
-- list so servers already on $PATH (e.g. system gopls) work as well
vim.lsp.enable(servers.ensure_installed)

vim.diagnostic.config({
    virtual_text = false,
    severity_sort = true,
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "x",
        },
    },
})

keymaps.setup_global()

api.nvim_create_autocmd("LspAttach", {
    group = api.nvim_create_augroup("MynvimLspAttach", { clear = true }),
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client then
            keymaps.on_attach(client, args.buf)
        end
    end,
})

api.nvim_create_autocmd("BufWritePre", {
    group = api.nvim_create_augroup("MynvimLspGo", { clear = true }),
    pattern = "*.go",
    callback = function(args)
        pcall(format.go_on_save, args.buf)
    end,
})

api.nvim_create_user_command("Rename", function()
    vim.lsp.buf.rename()
end, {})

api.nvim_create_user_command("Refactor", function()
    vim.lsp.buf.rename()
end, {})

api.nvim_create_user_command("Format", function()
    vim.lsp.buf.format({ timeout_ms = 2000 })
end, {})

api.nvim_create_user_command("OrganizeImports", function()
    format.organize_imports()
end, {})

api.nvim_create_user_command("Fold", function()
    vim.wo.foldmethod = "expr"
    vim.wo.foldexpr = "v:lua.vim.lsp.foldexpr()"
    vim.cmd("normal! zx")
end, {})
