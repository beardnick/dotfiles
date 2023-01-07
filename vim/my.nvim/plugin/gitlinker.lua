if not require 'plug'.loaded('gitlinker.nvim') then
    return
end
local osc52 = require('osc52')
require "gitlinker".setup({
    opts = {
        action_callback = function(url)
            osc52.copy(url)
        end,
        -- print the url after performing the action
        print_url = true,
    },
})


vim.api.nvim_set_keymap('n', '<leader>gl',
    '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>'
    , { silent = true })
vim.api.nvim_set_keymap('v', '<leader>gl',
    '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>'
    , {})
