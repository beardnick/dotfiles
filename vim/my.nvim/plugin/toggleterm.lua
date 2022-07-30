if not require('plug').loaded('toggleterm.nvim') then
    return
end

require("toggleterm").setup {
    -- size can be a number or function which is passed the current terminal
    size = function(term)
        if term.direction == "horizontal" then
            return 15
        elseif term.direction == "vertical" then
            return vim.o.columns * 0.4
        end
    end,
    open_mapping = [[<leader>at]],
    hide_numbers = true, -- hide the number column in toggleterm buffers
    shade_filetypes = {},
    shade_terminals = true,
    start_in_insert = true,
    insert_mappings = true, -- whether or not the open mapping applies in insert mode
    terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
    persist_size = true,
    direction = 'horizontal',
    --direction = 'vertical',
    close_on_exit = true, -- close the terminal window when the process exits
    shell = vim.o.shell, -- change the default shell
    -- This field is only relevant if direction is set to 'float'
    float_opts = {
        border = 'single',
        highlights = {
            border = "Normal",
            background = "Normal",
        }
    }
}

function _G.set_terminal_keymaps()
    local opts = { noremap = true }
    vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', [[<leader>aa]], [[<Cmd>ToggleTermToggleAll<CR>]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', [[<leader>tl]], [[<C-\><C-n><C-W>l]], opts)
    vim.api.nvim_buf_set_keymap(0, 't', [[<leader>th]], [[<C-\><C-n><C-W>h]], opts)
end

-- if you only want these mappings for toggle term use term://*toggleterm#* instead
vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

vim.api.nvim_set_keymap('n', [[<leader>aa]], [[<Cmd>ToggleTermToggleAll<CR>]], { noremap = true })

vim.api.nvim_create_autocmd({ "FileType" }, {
    pattern = { "sh" },
    callback = function()
        vim.api.nvim_set_keymap('n', [[<leader>ls]], [[<cmd>lua require'lang.bash'.send_cursor_cmd()<cr>]], { noremap = true, silent = true })
        --vim.api.nvim_buf_set_keymap(0,'v', [[<leader>ls]], [[<cmd>lua require'lang.bash'.send_lines()<CR>]], { noremap = true, silent = true })
        -- <cmd> wont change mode, cause range return zero
        vim.api.nvim_buf_set_keymap(0, 'v', [[<leader>ls]], [[:lua require'lang.bash'.send_lines()<cr>]], { noremap = true, silent = true })
        --vim.api.nvim_buf_set_keymap(0,'v', [[<leader>ls]], [[:lua require'xvim'.inspect_range()<CR>]], { noremap = true, silent = true })
    end
})
