--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local setupDap, setupDapVirtualText, setupPersistBreakPoint, setupDapUI, map, mapopt
local plug = require("plug")
function setupDap()
    local dap = require("dap")
    local dap_vscode = require("dap.ext.vscode")
    map("n", "<leader>dd", dap.toggle_breakpoint, mapopt)
    map("n", "<leader>di", dap.step_into, mapopt)
    map("n", "<leader>do", dap.step_out, mapopt)
    map("n", "<leader>dn", dap.step_over, mapopt)
    map(
        "n",
        "<leader>dc",
        function()
            if vim.fn.filereadable(".vim/launch.json") then
                dap_vscode.load_launchjs(".vim/launch.json")
            elseif vim.fn.filereadable(".vscode/launch.json") then
                dap_vscode.load_launchjs(".vscode/launch.json")
            end
            dap.continue()
        end,
        mapopt
    )
    map("n", "<leader>ds", dap.disconnect, mapopt)
    vim.fn.sign_define("DapBreakpoint", {text = "", texthl = "LspDiagnosticsSignError", linehl = "", numhl = ""})
    vim.fn.sign_define("DapBreakpointRejected", {text = "", texthl = "LspDiagnosticsSignHint", linehl = "", numhl = ""})
    vim.fn.sign_define("DapStopped", {text = "", texthl = "LspDiagnosticsSignInformation", linehl = "DiagnosticUnderlineInfo", numhl = "LspDiagnosticsSignInformation"})
    dap.adapters.go = {type = "server", port = "${port}", executable = {command = "dlv", args = {"dap", "-l", "127.0.0.1:${port}"}}}
    dap.configurations.go = {{type = "go", name = "Debug", request = "launch", program = "${file}"}, {name = "Launch Package", type = "go", request = "launch", program = "${fileDirname}"}, {
        type = "go",
        name = "Debug test",
        request = "launch",
        mode = "test",
        program = "${file}"
    }, {
        type = "go",
        name = "Debug test (go.mod)",
        request = "launch",
        mode = "test",
        program = "./${relativeFileDirname}"
    }}
end
function setupDapVirtualText()
    local dap_virtual_text = require("nvim-dap-virtual-text")
    dap_virtual_text.setup({
        enabled = true,
        enabled_commands = true,
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = true,
        virt_text_pos = "eol"
    })
end
function setupPersistBreakPoint()
    local persistent_breakpoints = require("persistent-breakpoints")
    local persistent_breakpoints_api = require("persistent-breakpoints.api")
    persistent_breakpoints.setup({load_breakpoints_event = {"BufReadPost"}})
    map("n", "<leader>dd", persistent_breakpoints_api.toggle_breakpoint, mapopt)
end
function setupDapUI()
    local dap = require("dap")
    local dapui = require("dapui")
    dapui.setup({
        icons = {expanded = "▾", collapsed = "▸"},
        mappings = {
            expand = {"<CR>", "<2-LeftMouse>"},
            open = "o",
            remove = "d",
            edit = "e",
            repl = "r",
            toggle = "t"
        },
        sidebar = {elements = {{id = "scopes", size = 0.25}, {id = "breakpoints", size = 0.25}, {id = "stacks", size = 0.25}, {id = "watches", size = 0.25}}, size = 40, position = "left"},
        tray = {elements = {"repl"}, size = 10, position = "bottom"},
        floating = {max_height = nil, max_width = nil, border = "single", mappings = {close = {"q", "<Esc>"}}},
        windows = {indent = 1}
    })
    dap.listeners.after.event_initialized.dapui_config = function() return dapui.open() end
    dap.listeners.before.event_terminated.dapui_config = function() return dapui.close() end
    dap.listeners.before.event_exited.dapui_config = function() return dapui.close() end
    map(
        "n",
        "<leader>dk",
        function() return dapui.float_element("scopes", {width = 100, height = 20, enter = true}) end,
        mapopt
    )
end
map = vim.keymap.set
mapopt = {noremap = true, silent = true}
if plug.loaded("nvim-dap") then
    setupDap()
end
if plug.loaded("nvim-dap-virtual-text") then
    setupDapVirtualText()
end
if plug.loaded("nvim-dap-ui") then
    setupDapUI()
end
if plug.loaded("persistent-breakpoints.nvim") then
    setupPersistBreakPoint()
end
return ____exports
