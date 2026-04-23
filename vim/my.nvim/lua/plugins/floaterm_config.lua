vim.g.floaterm_width = 0.7
vim.g.floaterm_height = 0.4
vim.g.floaterm_position = "top"
vim.g.floaterm_keymap_prev = "<Leader>fp"
vim.g.floaterm_keymap_next = "<Leader>fn"
vim.g.floaterm_keymap_toggle = "<Leader>ff"

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MynvimFloaterm", { clear = true }),
    pattern = "floaterm",
    callback = function()
        vim.cmd("highlight FloatermNF ctermbg=darkblue")
    end,
})
