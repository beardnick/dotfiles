vim.g.coc_clock_enabled = 0

vim.api.nvim_create_user_command("Clock", function()
    if vim.g.coc_clock_enabled == 1 then
        vim.cmd("CocCommand clock.disable")
        vim.g.coc_clock_enabled = 0
        return
    end

    vim.cmd("CocCommand clock.enable")
    vim.g.coc_clock_enabled = 1
end, {})
