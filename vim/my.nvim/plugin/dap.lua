local loaded = require'plug'.loaded

if not loaded('nvim-dap') then
    return
end

local map =vim.api.nvim_set_keymap

local mapopt = {noremap = true, silent = true}
map('n','<leader>dd',[[<cmd>lua require'dap'.toggle_breakpoint()<cr>]],mapopt)
map('n','<leader>di',[[<cmd>lua require'dap'.step_into()<cr>]],mapopt)
map('n','<leader>do',[[<cmd>lua require'dap'.step_out()<cr>]],mapopt)
map('n','<leader>dn',[[<cmd>lua require'dap'.step_over()<cr>]],mapopt)
map('n','<leader>dc',[[<cmd>lua require'dap'.continue()<cr>]],mapopt)


if loaded('nvim-dap-go') then
    require('dap-go').setup()
end

if loaded('nvim-dap-ui') then
require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      { id = "stacks", size = 0.25 },
      { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "left", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = { "repl" },
    size = 10,
    position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
})
end


if loaded('nvim-dap') and loaded('nvim-dap-ui') then
    local dap, dapui = require("dap"), require("dapui")
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end
    -- watch datas in float window
    map('n','<leader>dk',[[<cmd>lua require("dapui").float_element("scopes",{width = 100, height = 20, enter = true})<cr>]],mapopt)
end

if loaded('nvim-dap-virtual-text') then
    require("nvim-dap-virtual-text").setup {
        enabled = true,                     -- enable this plugin (the default)
        enabled_commands = true,            -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = true,   -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true,            -- show stop reason when stopped for exceptions
        commented = true,                  -- prefix virtual text with comment string
        -- experimental features:
        -- should be closed now
        --virt_text_pos = 'eol',              -- position of virtual text, see `:h nvim_buf_set_extmark()`
        --all_frames = true,                 -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        --virt_lines = true,                 -- show virtual lines instead of virtual text (will flicker!)
        --virt_text_win_col = nil             -- position the virtual text at a fixed window column (starting from the first text column) ,
                                            -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
    }
end

