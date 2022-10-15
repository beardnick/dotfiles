if not require 'plug'.loaded('hop.nvim') then
    return
end

require 'hop'.setup()

vim.api.nvim_set_keymap('n', 's', [[<cmd>HopChar1<cr>]], {})
