local M = {}

-- LSP servers auto-installed by mason-lspconfig, names follow nvim-lspconfig
M.ensure_installed = {
    "bashls",
    "clangd",
    "cmake",
    "cssls",
    "dockerls",
    "emmet_ls",
    "gopls",
    "html",
    "jdtls",
    "jsonls",
    "lemminx",
    "lua_ls",
    "pyright",
    "rust_analyzer",
    "solargraph",
    "ts_ls",
    "vimls",
    "yamlls",
    "zls",
}

-- extra cli tools auto-installed by mason-tool-installer
M.ensure_tools = {
    "impl", -- used by require("lang.go").goimpl
    "tree-sitter-cli", -- nvim-treesitter (main branch) compiles parsers with it
}

-- per-server overrides, translated from the old coc-settings.json
M.config = {
    gopls = {
        settings = {
            gopls = {
                completeUnimported = true,
                hints = {
                    assignVariableTypes = true,
                    compositeLiteralFields = true,
                    constantValues = true,
                    functionTypeParameters = true,
                    parameterNames = true,
                    rangeVariableTypes = true,
                },
            },
        },
    },
    lua_ls = {
        settings = {
            Lua = {
                workspace = { checkThirdParty = false },
            },
        },
    },
    ts_ls = {
        settings = {
            implicitProjectConfiguration = { checkJs = true },
        },
    },
    jdtls = {
        settings = {
            java = {
                import = {
                    maven = { enabled = true },
                    gradle = {
                        java = { home = "/Users/hugocheng/Library/Java/JavaVirtualMachines/jbr-17.0.5/Contents/Home" },
                    },
                },
                errors = { incompleteClasspath = { severity = "ignore" } },
                referencesCodeLens = { enabled = false },
                implementationsCodeLens = { enabled = false },
            },
        },
    },
}

return M
