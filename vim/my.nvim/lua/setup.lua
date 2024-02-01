--[[ Generated with https://github.com/TypeScriptToLua/TypeScriptToLua ]]
local ____exports = {}
local loadVscode, loadVim, ensurePluginManager, ensurePlugins, configCoc, configVim
local plug = require("plug")
function loadVscode()
    local vscode = require("vscode.init")
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
    end
    vscode.setup()
end
function loadVim()
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
        vim.g.cocData = tostring(vim.g.pluginDir) .. "/coc"
        vim.g.rootPath = vim.fn.fnamemodify(
            vim.fn.resolve(vim.fn.expand("<sfile>:p")),
            ":h"
        )
        vim.g.configDefault = tostring(vim.g.rootPath) .. "/default.vim"
    end
    vim.fn.execute(
        "source " .. tostring(vim.g.configDefault),
        "silent!"
    )
    ensurePluginManager(vim.g.pluginDir)
    ensurePlugins(vim.g.pluginDir)
    configCoc()
    configVim()
end
function ensurePluginManager(dir)
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
function ensurePlugins(dir)
    local lazy = require("lazy")
    lazy.setup({
        {[1] = "hrsh7th/nvim-cmp", dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "hrsh7th/cmp-buffer",
            "hrsh7th/cmp-path",
            "hrsh7th/cmp-cmdline",
            "quangnguyen30192/cmp-nvim-ultisnips",
            "ray-x/lsp_signature.nvim",
            "williamboman/mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            "neovim/nvim-lspconfig",
            "theHamsta/nvim-semantic-tokens",
            "lvimuser/lsp-inlayhints.nvim",
            "nvimtools/none-ls.nvim",
            "j-hui/fidget.nvim"
        }},
        "morhetz/gruvbox",
        "mg979/vim-visual-multi",
        "luochen1990/rainbow",
        "ludovicchabant/vim-gutentags",
        "mhinz/vim-startify",
        "scrooloose/nerdcommenter",
        "SirVer/ultisnips",
        "honza/vim-snippets",
        "plasticboy/vim-markdown",
        {[1] = "iamcco/markdown-preview.nvim", build = "cd app & yarn install"},
        "dhruvasagar/vim-table-mode",
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
        "tpope/vim-dadbod",
        "tpope/vim-dispatch",
        "andymass/vim-matchup",
        "wellle/tmux-complete.vim",
        "lervag/vimtex",
        "skywind3000/vim-quickui",
        "skywind3000/asynctasks.vim",
        "skywind3000/asyncrun.vim",
        "skywind3000/vim-keysound",
        "aperezdc/vim-template",
        "zenbro/mirror.vim",
        "antoinemadec/coc-fzf",
        "liuchengxu/vista.vim",
        "dearrrfish/vim-applescript",
        "skywind3000/vim-dict",
        "kristijanhusak/vim-dadbod-ui",
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
        {[1] = "beardnick/mynvim", build = "make"},
        "tpope/vim-fugitive",
        "ilyachur/cmake4vim",
        "ojroques/nvim-osc52",
        "akinsho/toggleterm.nvim",
        "mfussenegger/nvim-dap",
        "rcarriga/nvim-dap-ui",
        "sunjon/stylish.nvim",
        "rcarriga/nvim-notify",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
        {[1] = "nvim-telescope/telescope-fzf-native.nvim", build = "make"},
        "fannheyward/telescope-coc.nvim",
        "xiyaowong/nvim-transparent",
        "github/copilot.vim",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        "michaelb/sniprun",
        "nvim-orgmode/orgmode",
        {[1] = "beardnick/coc-go", branch = "feature-goimpl-list", build = "yarn install --frozen-lockfile"},
        "andythigpen/nvim-coverage",
        "ruifm/gitlinker.nvim",
        "will133/vim-dirdiff",
        {[1] = "folke/flash.nvim", branch = "main"},
        "norcalli/nvim-colorizer.lua"
    }, {root = dir})
end
function configCoc()
    if not plug.loaded("coc.nvim") then
        return
    end
    vim.g.coc_global_extensions = {
        "coc-actions@1.5.0",
        "coc-browser@1.5.0",
        "coc-calc@2.1.1",
        "coc-clock@0.0.12",
        "coc-css@1.3.0",
        "coc-dictionary@1.2.2",
        "coc-docker@0.5.0",
        "coc-emmet@1.1.6",
        "coc-explorer@0.22.6",
        "coc-git@2.4.7",
        "coc-gitignore@0.0.4",
        "coc-highlight@1.3.0",
        "coc-html@1.6.1",
        "coc-java@1.5.5",
        "coc-json@1.4.1",
        "coc-lines@0.5.0",
        "coc-lists@1.4.2",
        "coc-marketplace@1.8.1",
        "coc-omni@1.2.4",
        "coc-omnisharp@0.0.28",
        "coc-post@0.3.1",
        "coc-pyright@1.1.220",
        "coc-python@1.2.13",
        "coc-rust-analyzer@0.61.0",
        "coc-solargraph@1.2.3",
        "coc-syntax@1.2.4",
        "coc-tag@1.2.5",
        "coc-terminal@0.6.0",
        "coc-todolist@1.5.1",
        "coc-translator@1.7.2",
        "coc-tsserver@1.9.12",
        "coc-ultisnips@1.2.3",
        "coc-vetur@1.2.5",
        "coc-vimlsp@0.12.5",
        "coc-vimtex@1.1.1",
        "coc-xml@1.14.1",
        "coc-yaml@1.6.1",
        "coc-yank@1.2.1",
        "coc-fzf-preview@2.12.8",
        "coc-cmake@0.2.1",
        "coc-clangd@0.24.0",
        "coc-zi@1.1.2",
        "coc-symbol-line@0.0.20"
    }
end
function configVim()
    vim.fn["utils#source_path"](vim.g.rootPath, "ui")
    vim.fn["utils#source_path"](vim.g.rootPath, "lua/plugins")
    vim.fn["utils#source_path"](vim.g.rootPath, "lang")
    vim.g.localConfigAfter = vim.fn.expand("$HOME/.config/local/config_vim.vim")
    vim.g.localConfigLuaAfter = vim.fn.expand("$HOME/.config/local/config_nvim.lua")
    vim.fn.execute(
        "source " .. tostring(vim.g.localConfigAfter),
        "silent!"
    )
    vim.fn.execute(
        "luafile " .. tostring(vim.g.localConfigLuaAfter),
        "silent!"
    )
    print(vim.g.rootPath)
    vim.fn["utils#source_file"](vim.g.rootPath, "keybinding.vim")
end
function ____exports.setup()
    if vim.fn.exists("g:vscode") == 1 then
        loadVscode()
    else
        loadVim()
    end
end
return ____exports
