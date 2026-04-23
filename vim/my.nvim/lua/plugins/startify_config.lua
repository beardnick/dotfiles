if not require("plug").loaded("vim-startify") then
    return
end

vim.api.nvim_create_autocmd("TabNewEntered", {
    group = vim.api.nvim_create_augroup("MynvimStartify", { clear = true }),
    callback = function()
        vim.cmd("Startify")
    end,
})
