if vim.g.vscode then
    return
end

local commands = require("config.commands")

local tool_commands = {
    Tig = "tig",
    Python = "ptpython",
    Redis = "iredis",
    Lua = "lua",
    Navi = "navi",
    Vifm = function()
        return "vifm " .. vim.fn.getcwd()
    end,
    Ruby = "irb",
}

for name, cmd in pairs(tool_commands) do
    vim.api.nvim_create_user_command(name, function()
        local value = type(cmd) == "function" and cmd() or cmd
        commands.float_tool(value)
    end, {})
end

vim.api.nvim_create_user_command("FloatTool", function(opts)
    commands.float_tool(opts.args)
end, { nargs = 1 })
