local plug = require("plug")
local config_util = require("config.util")

local M = {}

local function source_local_configs()
    local lua_config = vim.fn.expand("$HOME/.config/local/config_nvim.lua")
    vim.g.localConfigLuaAfter = lua_config
    config_util.dofile_if_readable(lua_config)
end

local function load_vscode()
    local vscode = require("vs.init")
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
    end
    vscode.setup()
    source_local_configs()
end

local function ensure_plugin_manager(dir)
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

local function ensure_plugins(dir)
    local lazy = require("lazy")
    local lazy_opts = {root = dir}
    if vim.g.rootPath then
        lazy_opts.lockfile = vim.g.rootPath .. "/lazy-lock.json"
    end
    lazy.setup({
        "morhetz/gruvbox",
        "luochen1990/rainbow",
        "neovim/nvim-lspconfig",
        "mason-org/mason.nvim",
        "mason-org/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        "j-hui/fidget.nvim",
        {[1] = "saghen/blink.cmp", version = "1.*"},
        "rafamadriz/friendly-snippets",
        "mgalliou/blink-cmp-tmux",
        "Kaiser-Yang/blink-cmp-dictionary",
        "folke/lazydev.nvim",
        "lewis6991/gitsigns.nvim",
        "nvim-tree/nvim-tree.lua",
        "Bekaboo/dropbar.nvim",
        "gbprod/yanky.nvim",
        "nvim-treesitter/nvim-treesitter-textobjects",
        "nvim-telescope/telescope-ui-select.nvim",
        "mhinz/vim-startify",
        "scrooloose/nerdcommenter",
        "plasticboy/vim-markdown",
        {[1] = "iamcco/markdown-preview.nvim", build = "cd app & yarn install"},
        "gcmt/wildfire.vim",
        "tpope/vim-surround",
        "tpope/vim-repeat",
        "godlygeek/tabular",
        {[1] = "junegunn/fzf", build = ":call fzf#install()"},
        "junegunn/fzf.vim",
        "tweekmonster/fzf-filemru",
        "Yggdroot/indentLine",
        "tyru/open-browser.vim",
        "airblade/vim-rooter",
        "AndrewRadev/switch.vim",
        "kyazdani42/nvim-web-devicons",
        "romgrk/barbar.nvim",
        "junegunn/goyo.vim",
        "freitass/todo.txt-vim",
        "tpope/vim-scriptease",
        "tpope/vim-dispatch",
        -- "andymass/vim-matchup",
        "lervag/vimtex",
        "skywind3000/vim-quickui",
        "skywind3000/asynctasks.vim",
        "skywind3000/asyncrun.vim",
        "skywind3000/vim-keysound",
        "aperezdc/vim-template",
        "liuchengxu/vista.vim",
        "dearrrfish/vim-applescript",
        "skywind3000/vim-dict",
        "akiyosi/gonvim-fuzzy",
        "joshdick/onedark.vim",
        {[1] = "challenger-deep-theme/vim", name = "challenger-deep-theme"},
        "sickill/vim-monokai",
        "kurkale6ka/vim-swap",
        "tpope/vim-dotenv",
        "nvim-lualine/lualine.nvim",
        "rakr/vim-one",
        "tomasiser/vim-code-dark",
        "markonm/traces.vim",
        "t9md/vim-choosewin",
        "szw/vim-maximizer",
        "wellle/targets.vim",
        "rizzatti/dash.vim",
        "drmikehenry/vim-fixkey",
        "posva/vim-vue",
        {[1] = "yuki-yano/fzf-preview.vim", branch = "release/rpc"},
        "NLKNguyen/papercolor-theme",
        {[1] = "challenger-deep-theme/vim", name = "challenger-deep"},
        "liuchengxu/space-vim-dark",
        "hzchirs/vim-material",
        "patstockwell/vim-monokai-tasty",
        "unblevable/quick-scope",
        {[1] = "beardnick/vim-bookmarks", branch = "feature-relative-path"},
        "tpope/vim-fugitive",
        "ilyachur/cmake4vim",
        "ojroques/nvim-osc52",
        "rcarriga/nvim-dap-ui",
        "sunjon/stylish.nvim",
        "rcarriga/nvim-notify",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
        {[1] = "nvim-telescope/telescope-fzf-native.nvim", build = "make"},
        {[1] = "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
        "xiyaowong/nvim-transparent",
        "github/copilot.vim",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        "nvim-treesitter/playground",
        -- "michaelb/sniprun",
        "andythigpen/nvim-coverage",
        "ruifm/gitlinker.nvim",
        "will133/vim-dirdiff",
        {[1] = "folke/flash.nvim", branch = "main"},
        "norcalli/nvim-colorizer.lua",
        "folke/sidekick.nvim",
        {
            [1] = "beardnick/terminal_mate.nvim",
            lazy = false,
            config = function()
                require("terminal_mate").setup()
            end,
        },
    }, lazy_opts)
end

local function config_vim()
    config_util.load_dir(vim.g.rootPath, "ui")
    config_util.load_dir(vim.g.rootPath, "lua/plugins")
    config_util.load_dir(vim.g.rootPath, "lang")
    config_util.load_dir(vim.g.rootPath, "after/plugin")
    source_local_configs()
    config_util.dofile_if_readable(vim.g.keybindingConfig)
end

local function load_vim()
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
        vim.g.rootPath = vim.fn.fnamemodify(
            vim.fn.resolve(vim.fn.expand("<sfile>:p")),
            ":h"
        )
        vim.g.mynvim_root_path = vim.g.rootPath
        vim.g.configDefault = vim.g.rootPath .. "/default.lua"
        vim.g.keybindingConfig = vim.g.rootPath .. "/keybinding.lua"
    end
    config_util.dofile_if_readable(vim.g.configDefault)
    ensure_plugin_manager(vim.g.pluginDir)
    ensure_plugins(vim.g.pluginDir)
    config_vim()
end

function M.setup()
    if vim.fn.exists("g:vscode") == 1 then
        load_vscode()
    else
        load_vim()
    end
end

return M
