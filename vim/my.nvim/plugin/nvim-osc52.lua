if not require 'plug'.loaded('nvim-osc52') then
    return
end

require('osc52').setup()

vim.keymap.set('n', '<C-c>', require('osc52').copy_operator, {expr = true})
vim.keymap.set('x', '<C-c>', require('osc52').copy_visual)
