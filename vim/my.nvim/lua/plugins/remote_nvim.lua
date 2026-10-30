if not require("plug").loaded("remote-nvim.nvim") then
    return
end

local remote_nvim = require("remote-nvim")
remote_nvim.setup({
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

-- The pinned plugin only supports always/never copying config. Override its
-- preference hook so existing remote configs are reused, including hosts that
-- previously saved "Yes (always)". Keep setup/upload on the plugin's executor.
local Provider = require("remote-nvim.providers.provider")
function Provider:_get_neovim_config_upload_preference()
    local init_path = vim.fn.shellescape(self._remote_neovim_config_path .. "/init.lua")
    local present = "mynvim-config-present"
    self:run_command(
        ("if test -f %s; then printf '%%s' %s; fi"):format(init_path, vim.fn.shellescape(present)),
        "Checking for existing remote Neovim configuration"
    )
    return vim.trim(table.concat(self.executor:job_stdout(), "\n")) ~= present
end

local function sync_config(host_id)
    if host_id == nil then
        return
    end
    local session = remote_nvim.session_provider:get_session(host_id)
    if session == nil or session._remote_neovim_config_path == nil then
        vim.notify("Connect with :RemoteStart before syncing configuration", vim.log.levels.WARN)
        return
    end
    if session._setup_running then
        vim.notify("Remote setup or configuration sync is already running", vim.log.levels.WARN)
        return
    end

    session:_run_code_in_coroutine(function()
        session:start_progress_view_run("Sync Neovim configuration")
        session._setup_running = true
        local ok, err = pcall(function()
            session:upload(
                session._local_path_to_remote_neovim_config,
                session._remote_neovim_config_path,
                "Syncing local Neovim configuration onto remote",
                remote_nvim.config.remote.copy_dirs.config.compression
            )
        end)
        session._setup_running = false
        if not ok then
            error(err)
        end
        vim.notify("Remote configuration synced. Restart remote Neovim to load the changes.")
    end, "Syncing remote Neovim configuration")
end

vim.api.nvim_create_user_command("RemoteSyncConfig", function(opts)
    if opts.args ~= "" then
        sync_config(opts.args)
        return
    end
    local hosts = vim.tbl_keys(remote_nvim.session_provider:get_all_sessions())
    table.sort(hosts)
    if #hosts == 0 then
        vim.notify("Connect with :RemoteStart before syncing configuration", vim.log.levels.WARN)
        return
    end
    vim.ui.select(hosts, { prompt = "Sync configuration to remote session" }, sync_config)
end, {
    nargs = "?",
    desc = "Upload local Neovim configuration to a remote session",
    complete = function(prefix)
        local hosts = vim.tbl_keys(remote_nvim.session_provider:get_all_sessions())
        table.sort(hosts)
        return vim.tbl_filter(function(host) return vim.startswith(host, prefix) end, hosts)
    end,
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
vim.keymap.set("n", "<leader>ru", "<cmd>RemoteSyncConfig<CR>", { desc = "Remote Neovim: sync config" })
