-- Run with the installed dependencies and normal config:
-- nvim --headless '+lua dofile(vim.g.rootPath .. "/tests/remote_nvim_progress.lua")'
-- Exercises the UI lifecycle without opening an SSH connection.
local function drain_scheduled()
    local done = false
    vim.schedule(function() done = true end)
    assert(vim.wait(1000, function() return done end), "scheduled UI cleanup timed out")
end

local function check()
    local ProgressView = require("remote-nvim.ui.progressview")
    assert(ProgressView._mynvim_keep_progress_buffers, "progress view fix is not loaded")
    local view = ProgressView()
    local bufnr = view.progress_view.bufnr

    for run = 1, 3 do
        view:start_run("connection " .. run)
        view:show()
        local section = view:add_progress_node({ text = "connecting", type = "section_node" })
        vim.cmd.quit()
        drain_scheduled()
        assert(vim.api.nvim_buf_is_valid(bufnr), ":q deleted the persistent progress buffer")
        -- Jobs may still report progress after their window is closed.
        view:update_status("success", true, section)
        view:show()
        view:switch_to_pane("session_info", true)
        view:hide()
        view:update_status("success", true, section)
        view:show()
        view:switch_to_pane("help")
        view:hide()
    end

    -- Sourcing this config again must not stack the compatibility wrapper.
    local init = ProgressView.init
    dofile(vim.g.rootPath .. "/lua/plugins/remote_nvim.lua")
    assert(ProgressView.init == init, "config reload installed a second wrapper")
    view:start_run("after config reload")
    view:show()
    view:hide()
end

local ok, err = xpcall(check, debug.traceback)
if not ok then
    io.stderr:write(err .. "\n")
    vim.cmd.cquit()
end
print("remote progress close/reopen regression: OK")
vim.cmd.qa()
