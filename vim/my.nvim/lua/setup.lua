local plug = require("plug")
local config_util = require("config.util")

-- Config root derived from this file's own location (lua/setup.lua →
-- two levels up). NOT expand("<sfile>"): when this config is loaded from
-- another runtime (rnvim's user_config dofile), <sfile> points at the
-- caller's script and every config path resolves into the wrong tree.
local module_root = vim.fn.fnamemodify(
    vim.fn.resolve(debug.getinfo(1, "S").source:sub(2)),
    ":p:h:h"
)

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

-- Workspace-coupled plugins: they read the local filesystem, run local
-- commands, or manage local tooling. In rnvim the workspace lives on the
-- remote host and these capabilities are provided by rnvim itself
-- (finder/grep, LSP proxy with remote auto-install, dir browser), so this
-- set is excluded there. Everything else — completion, treesitter, themes,
-- pure editing — is shared. Matching is by lazy's short name.
local rnvim_excluded = {
    -- LSP tooling: rnvim owns LSP (remote servers behind its proxy)
    ["nvim-lspconfig"] = true,
    ["mason.nvim"] = true,
    ["mason-lspconfig.nvim"] = true,
    ["mason-tool-installer.nvim"] = true,
    -- finders: rnvim provides <C-p>/<C-g> against the remote workspace
    ["fzf"] = true,
    ["fzf.vim"] = true,
    ["fzf-filemru"] = true,
    ["fzf-preview.vim"] = true,
    ["telescope.nvim"] = true,
    ["telescope-fzf-native.nvim"] = true,
    ["gonvim-fuzzy"] = true,
    -- local-fs explorers / git / diff
    ["nvim-tree.lua"] = true,
    ["gitsigns.nvim"] = true,
    ["vim-fugitive"] = true,
    ["diffview.nvim"] = true,
    ["gitlinker.nvim"] = true,
    ["vim-dirdiff"] = true,
    ["vim-rooter"] = true,
    ["vim-bookmarks"] = true,
    ["vim-startify"] = true,
    -- local exec / build / debug / coverage
    ["asynctasks.vim"] = true,
    ["asyncrun.vim"] = true,
    ["vim-dispatch"] = true,
    ["cmake4vim"] = true,
    ["vista.vim"] = true,
    -- NOTE: the nvim-dap stack stays INCLUDED: rnvim.dap debugs remote
    -- runnables through it (adapter runs remotely, client UI is local)
    ["nvim-coverage"] = true,
    ["markdown-preview.nvim"] = true,
    ["vimtex"] = true,
    ["vim-template"] = true,
    ["vim-scriptease"] = true,
    ["dash.vim"] = true,
    ["vim-applescript"] = true,
}

local plugin_specs

local function lazy_short_name(spec)
    local repo = type(spec) == "table" and (spec.name or spec[1]) or spec
    return repo:match("([^/]+)$")
end

local function ensure_plugins(dir, opts)
    opts = opts or {}
    local lazy = require("lazy")
    local lazy_opts = {
        root = dir,
        -- keep foreign runtimes (e.g. the rnvim managed runtime) on rtp
        performance = {rtp = {reset = false}},
    }
    if vim.g.rootPath then
        lazy_opts.lockfile = vim.g.rootPath .. "/" .. (opts.lockfile or "lazy-lock.json")
    end
    local specs = plugin_specs()
    if opts.exclude then
        specs = vim.tbl_filter(function(spec)
            return not opts.exclude[lazy_short_name(spec)]
        end, specs)
    end
    lazy.setup(specs, lazy_opts)
end

plugin_specs = function()
    return {
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
        {[1] = "nvim-treesitter/nvim-treesitter-textobjects", branch = "main"},
        "stevearc/dressing.nvim",
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
        "mfussenegger/nvim-dap",
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "sunjon/stylish.nvim",
        "rcarriga/nvim-notify",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
        {[1] = "nvim-telescope/telescope-fzf-native.nvim", build = "make"},
        {[1] = "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate"},
        "xiyaowong/nvim-transparent",
        "github/copilot.vim",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        -- playground is deprecated: use builtin :InspectTree / :EditQuery
        -- "michaelb/sniprun",
        "andythigpen/nvim-coverage",
        "ruifm/gitlinker.nvim",
        "will133/vim-dirdiff",
        {[1] = "folke/flash.nvim", branch = "main"},
        "norcalli/nvim-colorizer.lua",
        "folke/sidekick.nvim",
        -- rnvim: remote development (both personalities need it — the
        -- remote instance is its whole point, the local instance gets
        -- :RnvimConnect). Local checkout preferred for development.
        (function()
            local dev = vim.fn.expand("~/workspace/rnvim")
            if vim.uv.fs_stat(dev) then
                return {dir = dev, name = "rnvim", lazy = false}
            end
            return {[1] = "beardnick/rnvim", lazy = false}
        end)(),
        {
            [1] = "beardnick/terminal_mate.nvim",
            lazy = false,
            config = function()
                require("terminal_mate").setup()
            end,
        },
    }
end

local function config_vim()
    config_util.load_dir(vim.g.rootPath, "ui")
    config_util.load_dir(vim.g.rootPath, "lua/plugins")
    config_util.load_dir(vim.g.rootPath, "lang")
    config_util.load_dir(vim.g.rootPath, "after/plugin")
    source_local_configs()
    config_util.dofile_if_readable(vim.g.keybindingConfig)
end

local function init_paths()
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
        vim.g.rootPath = module_root
        vim.g.mynvim_root_path = vim.g.rootPath
        vim.g.configDefault = vim.g.rootPath .. "/default.lua"
        vim.g.keybindingConfig = vim.g.rootPath .. "/keybinding.lua"
    end
end

local function load_vim()
    init_paths()
    config_util.dofile_if_readable(vim.g.configDefault)
    ensure_plugin_manager(vim.g.pluginDir)
    ensure_plugins(vim.g.pluginDir)
    config_vim()
end

-- Inside rnvim (vim.g.rnvim = { target }, set via --cmd before this file
-- runs): same config pipeline, but workspace-coupled plugins stay out —
-- rnvim provides the finder, LSP (with remote server auto-install) and
-- terminals against the remote workspace. Every plugin config file guards
-- with plug.loaded(), so the excluded plugins' configs no-op on their own.
-- Since v0.10 rnvim is a plain plugin in this same nvim: plugin clones are
-- shared with the local personality, only the lockfile is separate.
local function load_rnvim()
    init_paths()
    config_util.dofile_if_readable(vim.g.configDefault)
    ensure_plugin_manager(vim.g.pluginDir)
    ensure_plugins(vim.g.pluginDir, {
        exclude = rnvim_excluded,
        lockfile = "lazy-lock-rnvim.json",
    })
    config_vim()
end

function M.setup()
    if vim.fn.exists("g:vscode") == 1 then
        load_vscode()
    elseif vim.g.rnvim then
        load_rnvim()
    else
        load_vim()
    end
end

return M
