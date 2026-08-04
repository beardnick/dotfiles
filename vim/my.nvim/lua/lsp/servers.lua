local M = {}

local function open_terminal(cmd, cwd)
    vim.cmd("botright 15new")
    vim.fn.jobstart(cmd, { term = true, cwd = cwd })
    vim.cmd.startinsert()
end

-- rust-analyzer code lenses ("Run Test" etc.) send client-side commands
-- that editors must implement themselves; translate them to cargo runs.
-- Inside rnvim the workspace root arrives as the local ws-prefix path:
-- translate it back and run cargo on the workspace host over ssh.
local function rust_run_single(command)
    local runnable = command.arguments and command.arguments[1]
    local args = runnable and runnable.args
    if not runnable or runnable.kind ~= "cargo" or not args then
        vim.notify("unsupported rust-analyzer runnable", vim.log.levels.WARN)
        return
    end
    local cmd = { "cargo" }
    vim.list_extend(cmd, args.cargoArgs or {})
    vim.list_extend(cmd, args.cargoExtraArgs or {})
    if args.executableArgs and #args.executableArgs > 0 then
        table.insert(cmd, "--")
        vim.list_extend(cmd, args.executableArgs)
    end

    local root = args.workspaceRoot
    if vim.g.rnvim then
        local ws = require("rnvim.workspace").current()
        if ws and root and vim.startswith(root, ws.ws_root) then
            root = root:sub(#ws.ws_root + 1)
        end
        if ws and ws.host ~= "local" then
            open_terminal({
                "ssh",
                "-t",
                ws.host,
                ("cd %s && exec %s"):format(vim.fn.shellescape(root or "~"), table.concat(cmd, " ")),
            })
            return
        end
    end
    open_terminal(cmd, root)
end

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
    rust_analyzer = {
        commands = {
            ["rust-analyzer.runSingle"] = rust_run_single,
            ["rust-analyzer.debugSingle"] = function()
                vim.notify("debugging runnables is not wired up (needs rustaceanvim)", vim.log.levels.WARN)
            end,
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
