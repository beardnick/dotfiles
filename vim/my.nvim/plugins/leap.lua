if not require 'plug'.loaded('leap.nvim') then
    return
end

require('leap').setup({})

vim.keymap.set({'n','x','o'},'s','<Plug>(leap-forward-to)')
vim.keymap.set({'n','x','o'},'S','<Plug>(leap-backward-to)')
