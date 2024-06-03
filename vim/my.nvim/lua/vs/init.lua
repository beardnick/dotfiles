-- vim: set foldmethod=marker fdl=0:
local map = vim.keymap.set;
local mapopt = { noremap = true, silent = true }
local vscode = require("vscode-neovim")

vim.notify = vscode.notify

local M = {}

local function ensurePluginManager(dir)
    local lazypath = dir .. "/lazy.nvim"
    if not vim.loop.fs_stat(lazypath) then
        vim.fn.system({
            "git",
            "clone",
            "--filter=blob:none",
            "https://github.com/folke/lazy.nvim.git",
            "--branch=stable",
            lazypath
        })
    end
    vim.opt.runtimepath:prepend(lazypath)
end


local function ensurePlugins(dir)
    local lazy = require("lazy")

    lazy.setup({
        'rcarriga/nvim-notify',
        'unblevable/quick-scope',
        { [1] = 'folke/flash.nvim', branch = 'main' },
        'tpope/vim-surround',
        'ruifm/gitlinker.nvim',
        'nvim-lua/plenary.nvim',
    })
end


local function vscode_call(s)
    return function()
        vscode.call(s)
    end
end

local function maximize_editor()
    vscode.call("workbench.action.closeSidebar")
    vscode.call("workbench.action.closePanel")
end

local function loadConfig()
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

    map('n', 's', [[<cmd>lua require('flash').jump()<cr>]], mapopt)

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

    -- 设置leader为空格
    vim.g.mapleader = " "

    --}}}

    --{{{ mapping


    map('n', '<leader>wm', maximize_editor, mapopt)
    --map('n', '<C-a>',function vscode.call("workbench.action.focusLastEditorGroup") end, mapopt)
    --map('n', '<C-p>',function() vscode.call("workbench.action.quickOpen")  end, mapopt)
    --map('n', '<leader>ws','<C-w>s', mapopt)
    --map('n', '<leader>wo','<C-w>o', mapopt)
    --map('n', '<leader>wv','<C-w>v', mapopt)
    --map('n', '<leader>ws','<C-w>s', mapopt)
    --map('n', '<leader>ws','<C-w>s', mapopt)
    map('n', 'zc', vscode_call("editor.fold"), mapopt)
    map('n', 'zo', vscode_call("editor.unfold"), mapopt)
    map('n', 'zM', vscode_call("editor.foldAll"), mapopt)
    map('n', 'zR', vscode_call("editor.unfoldAll"), mapopt)

    map('n', ']c', vscode_call("workbench.action.editor.nextChange"), mapopt)
    map('n', '[c', vscode_call("workbench.action.editor.previousChange"), mapopt)

    map('n', 'mi', vscode_call("bookmarks.toggleLabeled"), mapopt)
    map('n', 'ma', vscode_call("bookmarks.listFromAllFiles"), mapopt)
    map('n', 'mm', vscode_call("bookmarks.toggle"), mapopt)


    map('n', '<leader><leader>', vscode_call("workbench.action.showCommands"), mapopt)

    map('n', '<leader>;', vscode_call("editor.action.commentLine"), mapopt)
    map('v', '<leader>;', vscode_call("editor.action.commentLine"), mapopt)

    map('n', '<C-P>', vscode_call("workbench.action.quickOpen"), mapopt)

    --" file
    map('n', '<leader>fs', vscode_call("workbench.action.quickOpen"), mapopt)
    map('n', '<leader>ft', vscode_call("workbench.files.action.focusFilesExplorer"), mapopt)

    --" tag
    map('n', '<leader>tb', vscode_call("outline.focus"), mapopt)

    --" search
    map('n', '<leader>sw', [[<cmd>Rg <C-R><C-W>]], mapopt)
    map('n', '<leader>sr', vscode_call("workbench.action.findInFiles"), mapopt)
    map('n', '<leader>sf', vscode_call("workbench.action.quickOpen"), mapopt)

    map('n', 'K', vscode_call("editor.action.showHover"), mapopt)

    --}}}
end

function M.setup()
    ensurePluginManager(vim.g.pluginDir)
    ensurePlugins(vim.g.pluginDir)
    loadConfig()
end

return M
