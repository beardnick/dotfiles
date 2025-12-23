local plug = require("plug")

local M = {}

local function source_local_configs()
    local vim_config = vim.fn.expand("$HOME/.config/local/config_vim.vim")
    local lua_config = vim.fn.expand("$HOME/.config/local/config_nvim.lua")
    vim.g.localConfigAfter = vim_config
    vim.g.localConfigLuaAfter = lua_config
    vim.cmd(string.format("silent! source %s", vim.fn.fnameescape(vim_config)))
    vim.cmd(string.format("silent! luafile %s", vim.fn.fnameescape(lua_config)))
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

local function checksum_cache_path(root)
    if not root then
        return nil
    end
    return root .. "/.lazy-lock.sha256"
end

local function read_lock_checksum(lockfile)
    if not lockfile or vim.fn.filereadable(lockfile) ~= 1 then
        return nil
    end
    local ok, lines = pcall(vim.fn.readfile, lockfile)
    if not ok or not lines then
        return nil
    end
    return vim.fn.sha256(table.concat(lines, "\n"))
end

local function read_cached_checksum(root)
    local path = checksum_cache_path(root)
    if not path or vim.fn.filereadable(path) ~= 1 then
        return nil
    end
    local ok, lines = pcall(vim.fn.readfile, path)
    if not ok or not lines or #lines == 0 then
        return nil
    end
    return lines[1]
end

local function write_cached_checksum(root, checksum)
    local path = checksum_cache_path(root)
    if not path or not checksum then
        return
    end
    vim.fn.mkdir(root, "p")
    pcall(vim.fn.writefile, {checksum}, path)
end

local function try_restore(lazy_mod, root, lockfile)
    local ok_stats, stats = pcall(function()
        return lazy_mod.stats()
    end)
    local missing = 0
    if ok_stats and stats and stats.missing then
        missing = stats.missing
    end
    local desired_checksum = read_lock_checksum(lockfile)
    local cached_checksum = read_cached_checksum(root)
    local needs_restore = missing > 0 or (desired_checksum and desired_checksum ~= cached_checksum)
    local restore_fn = type(lazy_mod.restore) == "function" and lazy_mod.restore
        or type(lazy_mod.sync) == "function" and lazy_mod.sync
        or nil
    if not needs_restore or not restore_fn then
        return
    end
    local opts = {wait = true, show = false}
    local restore_ok, err = pcall(restore_fn, opts)
    if restore_ok then
        if desired_checksum then
            write_cached_checksum(root, desired_checksum)
        end
    elseif err then
        vim.schedule(function()
            vim.notify(string.format("lazy.nvim restore failed: %s", err), vim.log.levels.ERROR)
        end)
    end
end

local function ensure_plugins(dir)
    local lazy = require("lazy")
    local lazy_opts = {root = dir}
    if vim.g.rootPath then
        lazy_opts.lockfile = vim.g.rootPath .. "/lazy-lock.json"
    end
    lazy.setup({
        "morhetz/gruvbox",
        "mg979/vim-visual-multi",
        "luochen1990/rainbow",
        {[1] = "neoclide/coc.nvim", branch = "master", build = "yarn install --frozen-lockfile"},
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
        -- "andymass/vim-matchup",
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
        "rcarriga/nvim-dap-ui",
        "sunjon/stylish.nvim",
        "rcarriga/nvim-notify",
        "nvim-lua/plenary.nvim",
        "sindrets/diffview.nvim",
        "nvim-telescope/telescope.nvim",
        {[1] = "nvim-telescope/telescope-fzf-native.nvim", build = "make"},
        "fannheyward/telescope-coc.nvim",
        {[1] = "nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
        "xiyaowong/nvim-transparent",
        "github/copilot.vim",
        "theHamsta/nvim-dap-virtual-text",
        "Weissle/persistent-breakpoints.nvim",
        "nvim-treesitter/playground",
        -- "michaelb/sniprun",
        {[1] = "beardnick/coc-go", branch = "feature-goimpl-list", build = "yarn install --frozen-lockfile"},
        "andythigpen/nvim-coverage",
        "ruifm/gitlinker.nvim",
        "will133/vim-dirdiff",
        {[1] = "folke/flash.nvim", branch = "main"},
        "norcalli/nvim-colorizer.lua"
    }, lazy_opts)
    try_restore(lazy, lazy_opts.root, lazy_opts.lockfile)
end

local function config_coc()
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
        --"coc-translator@1.7.2",
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
        "coc-symbol-line@0.0.20",
        "coc-sumneko-lua@0.0.42"
    }
end

local function config_vim()
    vim.fn["utils#source_path"](vim.g.rootPath, "ui")
    vim.fn["utils#source_path"](vim.g.rootPath, "lua/plugins")
    vim.fn["utils#source_path"](vim.g.rootPath, "lang")
    source_local_configs()
    print(vim.g.rootPath)
    vim.fn["utils#source_file"](vim.g.rootPath, "keybinding.vim")
end

local function load_vim()
    if not vim.g.pluginDir then
        vim.g.pluginDir = vim.fn.stdpath("data") .. "/mynvim"
        vim.g.cocData = vim.g.pluginDir .. "/coc"
        vim.g.rootPath = vim.fn.fnamemodify(
            vim.fn.resolve(vim.fn.expand("<sfile>:p")),
            ":h"
        )
        vim.g.configDefault = vim.g.rootPath .. "/default.vim"
    end
    vim.cmd(string.format("silent! source %s", vim.fn.fnameescape(vim.g.configDefault)))
    ensure_plugin_manager(vim.g.pluginDir)
    ensure_plugins(vim.g.pluginDir)
    config_coc()
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
