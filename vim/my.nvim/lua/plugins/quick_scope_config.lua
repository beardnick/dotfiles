if not require("plug").loaded("quick-scope") then
    return
end

vim.api.nvim_set_hl(0, "QuickScopePrimary", {
    fg = "#afff5f",
    underline = true,
    ctermfg = 155,
    cterm = { underline = true },
})
vim.api.nvim_set_hl(0, "QuickScopeSecondary", {
    fg = "#5fffff",
    underline = true,
    ctermfg = 81,
    cterm = { underline = true },
})
