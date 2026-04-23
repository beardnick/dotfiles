vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MynvimJavascriptIndent", { clear = true }),
    pattern = { "typescript", "javascript" },
    callback = function()
        vim.opt_local.shiftwidth = 2
    end,
})
