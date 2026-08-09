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

-- debugSingle: build the runnable with cargo, then launch the produced
-- binary under codelldb via nvim-dap (what the VSCode extension does)
local function rust_debug_single(command)
    local runnable = command.arguments and command.arguments[1]
    local args = runnable and runnable.args
    if not runnable or runnable.kind ~= "cargo" or not args then
        vim.notify("unsupported rust-analyzer runnable", vim.log.levels.WARN)
        return
    end
    if vim.g.rnvim then
        local ws = require("rnvim.workspace").current()
        if ws and ws.host ~= "local" then
            local ok, rdap = pcall(require, "rnvim.dap.rust")
            if ok and rdap.debug_runnable then
                rdap.debug_runnable(runnable)
            else
                vim.notify("remote debugging needs a newer rnvim (rnvim.dap.rust missing)", vim.log.levels.WARN)
            end
            return
        end
    end

    local build = { "cargo" }
    vim.list_extend(build, args.cargoArgs or {})
    vim.list_extend(build, args.cargoExtraArgs or {})
    if build[2] == "run" then
        build[2] = "build"
    else
        table.insert(build, "--no-run")
    end
    table.insert(build, "--message-format=json")

    vim.notify("building " .. (runnable.label or "runnable") .. "…")
    vim.system(build, { cwd = args.workspaceRoot, text = true }, vim.schedule_wrap(function(out)
        if out.code ~= 0 then
            vim.notify("cargo build failed:\n" .. (out.stderr or ""), vim.log.levels.ERROR)
            return
        end
        local executable
        for line in (out.stdout or ""):gmatch("[^\n]+") do
            local ok, msg = pcall(vim.json.decode, line)
            if ok and type(msg) == "table" and msg.executable and msg.executable ~= vim.NIL then
                executable = msg.executable
            end
        end
        if not executable then
            vim.notify("no debuggable executable produced", vim.log.levels.ERROR)
            return
        end
        require("dap").run({
            name = runnable.label or "rust debug",
            type = "codelldb",
            request = "launch",
            program = executable,
            args = args.executableArgs or {},
            cwd = args.workspaceRoot,
            stopOnEntry = false,
        })
    end))
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
    -- debug adapters
    "codelldb", -- rust / c / cpp
    "delve", -- go
    "debugpy", -- python
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
            ["rust-analyzer.debugSingle"] = rust_debug_single,
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
