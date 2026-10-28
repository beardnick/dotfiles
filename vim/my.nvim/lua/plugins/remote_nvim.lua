if not require("plug").loaded("remote-nvim.nvim") then
    return
end

require("remote-nvim").setup({
    remote = {
        -- The plugin places this under its own remote XDG directories.
        -- Also identifies the remote runtime before user config loads.
        app_name = "mynvim-remote",
        copy_dirs = {
            config = {
                -- ~/.config/nvim is a symlink into this dotfiles checkout.
                base = vim.fn.resolve(vim.g.rootPath),
                dirs = "*",
            },
            -- Install dependencies on the remote platform. In particular,
            -- do not copy macOS parsers, native plugins or Mason binaries.
            data = { dirs = {} },
            cache = { dirs = {} },
            state = { dirs = {} },
        },
    },
})

-- Providers reuse their ProgressView between connections, but NuiPopup's
-- QuitPre handler unmounts it and deletes the buffer its trees still use.
-- Keep this particular popup alive when closed, just like its `q` mapping
-- does. Terminal popups and other Nui users retain their normal lifecycle.
local ProgressView = require("remote-nvim.ui.progressview")
if not ProgressView._mynvim_keep_progress_buffers then
    local init = ProgressView.init
    function ProgressView:init(...)
        init(self, ...)
        self.progress_view.unmount = self.progress_view.hide
    end
    ProgressView._mynvim_keep_progress_buffers = true
end

vim.keymap.set("n", "<leader>rs", "<cmd>RemoteStart<CR>", { desc = "Remote Neovim: connect" })
vim.keymap.set("n", "<leader>ri", "<cmd>RemoteInfo<CR>", { desc = "Remote Neovim: session info" })
