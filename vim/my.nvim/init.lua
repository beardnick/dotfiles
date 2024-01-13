require('setup').setup()

vim.keymap.set("n", "<leader>sv", function() require('setup').setup() end, {noremap = true,silent = true})
