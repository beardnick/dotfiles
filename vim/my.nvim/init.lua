local config_root = vim.fn.fnamemodify(
    vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)),
    ":p:h"
)

vim.opt.runtimepath:prepend(config_root)

require('setup').setup()

vim.keymap.set("n", "<leader>sv", function() require('setup').setup() end, {noremap = true,silent = true})
