-- vim: set foldmethod=marker fdl=0:
local map = vim.keymap.set;
local mapopt = { noremap = true, silent = true }
local vscode = require("vscode-neovim")

vim.notify = vscode.notify

-- {{{ flash

require('flash').setup(
    {
        modes = {
            char = {
                enabled = false
            }
        },
        highlight = {
            -- show a backdrop with hl FlashBackdrop
            backdrop = false,
        }

    }
)

map('n', 's', require('flash').jump, mapopt)

vim.api.nvim_set_hl(0, "FlashLabel", { ctermbg = 0, bg = '#fa036a' })
vim.api.nvim_set_hl(0, "FlashMatch", { ctermbg = 0, bg = '#2f50cd' })
vim.api.nvim_set_hl(0, "FlashCurrent", { ctermbg = 0, bg = '#2f50cd' })

-- }}}

-- {{{ quick scope

vim.cmd [[
    highlight QuickScopePrimary guifg='#afff5f' gui=underline ctermfg=155 cterm=underline
    highlight QuickScopeSecondary guifg='#5fffff' gui=underline ctermfg=81 cterm=underline
]]

--}}}

-- {{{ gitlinker

map('n', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("n")<cr>', { silent = true })
map('v', '<leader>gl', '<cmd>lua require"gitlinker".get_buf_range_url("v")<cr>', {})

--}}}

--{{{ vim options

vim.o.ignorecase = true

--}}}

--{{{ functions

function maximize_editor()
    vscode.call("workbench.action.closeSidebar")
    vscode.call("workbench.action.closePanel")
end

--}}}

--{{{ mapping

map('n', '<leader>wm', maximize_editor, mapopt)
--map('n', '<C-a>',function vscode.call("workbench.action.focusLastEditorGroup") end, mapopt)
--map('n', '<C-p>',function() vscode.call("workbench.action.quickOpen")  end, mapopt)
--map('n', '<leader>ws','<C-w>s', mapopt)
--map('n', '<leader>wo','<C-w>o', mapopt)
--map('n', '<leader>wv','<C-w>v', mapopt)
--map('n', '<leader>ws','<C-w>s', mapopt)

--}}}
