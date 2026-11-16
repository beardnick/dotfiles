local plug = require("plug")

if not plug.loaded("yanky.nvim") then
    return
end

-- Focus sync reads the system clipboard. In remote sessions OSC 52 writes
-- can succeed while reads never receive a response, blocking Neovim on focus
-- changes. Keep recording local yanks without polling the remote clipboard.
local remote_session = vim.env.NVIM_APPNAME == "mynvim-remote"
    or vim.g.remote_neovim_host == true
    or vim.env.SSH_CONNECTION ~= nil

require("yanky").setup({
    system_clipboard = { sync_with_ring = not remote_session },
    ring = { history_length = 100 },
    highlight = { on_put = false, on_yank = false },
})

if plug.loaded("telescope.nvim") then
    require("telescope").load_extension("yank_history")
end
