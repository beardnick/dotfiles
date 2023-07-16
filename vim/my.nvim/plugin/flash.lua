if not require('plug').loaded('flash.nvim') then
    return
end

local map =vim.api.nvim_set_keymap
local mapopt = {noremap = true, silent = true}

require('flash').setup()

map('n','s',[[<cmd>lua require('flash').jump()<cr>]],mapopt)

vim.api.nvim_set_hl(0, "FlashLabel", { ctermbg=0, bg='#fa036a' })
vim.api.nvim_set_hl(0, "FlashMatch", { ctermbg=0, bg='#2f50cd' })
vim.api.nvim_set_hl(0, "FlashCurrent", { ctermbg=0, bg='#2f50cd' })
