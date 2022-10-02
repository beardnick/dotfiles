if not require 'plug'.loaded('vim-oscyank') then
    return
end

vim.g.oscyank_term = 'default'
-- yank with osc52 protocol that can yank over ssh
vim.api.nvim_set_keymap('v', '<C-c>', [[:OSCYank<cr>]], { noremap = true, silent = true })
