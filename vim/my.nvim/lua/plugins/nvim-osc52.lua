if not require 'plug'.loaded('nvim-osc52') then
    return
end

require('osc52').setup()

-- The legacy OSC52 plugin writes to stderr, which belongs to the headless
-- server rather than the attached remote UI. Native clipboard yanks use the
-- UI-aware provider that already handles explicit "+y in remote sessions.
local remote_session = vim.env.NVIM_APPNAME == "mynvim-remote"
    or vim.g.remote_neovim_host == true
    or vim.env.SSH_CONNECTION ~= nil
if remote_session then
    vim.keymap.set({ "n", "x" }, "<C-c>", '"+y', { silent = true, desc = "Copy to system clipboard" })
    return
end

vim.keymap.set('n', '<C-c>', require('osc52').copy_operator, {expr = true})
vim.keymap.set('x', '<C-c>', require('osc52').copy_visual)
