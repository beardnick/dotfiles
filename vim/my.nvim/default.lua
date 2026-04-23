local api = vim.api
local commands = require("config.commands")

vim.g.mynvim_colorscheme = "one"
vim.g.mynvim_colorscheme_backgroud = "dark"
vim.g.mynvim_keysound_enable = 0
vim.g.mynvim_banner = {
    "                    .                    ",
    "    ##############..... ##############   ",
    "    ##############......##############   ",
    "      ##########..........##########     ",
    "      ##########........##########       ",
    "      ##########.......##########        ",
    "      ##########.....##########..        ",
    "      ##########....##########.....      ",
    "    ..##########..##########.........    ",
    "  ....##########.#########.............  ",
    "    ..################JJJ............    ",
    "      ################.............      ",
    "      ##############.JJJ.JJJJJJJJJJ      ",
    "      ############...JJ...JJ..JJ  JJ     ",
    "      ##########....JJ...JJ..JJ  JJ      ",
    "      ########......JJJ..JJJ JJJ JJJ     ",
    "      ######    .........                ",
    "                  .....                  ",
    "                    .                    ",
}

vim.g.Lf_WindowPosition = "popup"
vim.g.Lf_ShortcutB = "<LEADER>bs"
vim.g.Lf_ShortcutF = ""
vim.g.buftabline_numbers = 2
vim.g.buftabline_separators = 1
vim.g["quickrun#default_config"] = {
    ["_"] = {
        runner = "terminal",
    },
}
vim.g.rooter_patterns = { ".vim", ".git", ".git/", "_darcs/", ".hg/", ".bzr/", ".svn/", "go.mod" }
vim.g.bookmark_save_per_working_dir = 1
vim.g.bookmark_save_relative_dir = 1
vim.g.quickui_border_style = 2
vim.g.quickui_color_scheme = "gruvbox"
vim.g.mkdp_auto_start = 0
vim.g.tex_flavor = "latex"
vim.g.vim_json_syntax_conceal = 0
vim.g.vimtex_view_method = "skim"
vim.g.livepreview_engine = "xelatex"
vim.g.terminal_height = 20
vim.g.terminal_pos = "botright"
vim.g.go_template_autocreate = 0
vim.g.go_template_use_pkg = 1
vim.g.go_gopls_enabled = 0
vim.g.go_rename_command = "gopls"
vim.g.go_fmt_fail_silently = 1
vim.g.go_def_mapping_enabled = 0
vim.g.templates_no_autocmd = 1
vim.g.vimspector_enable_mappings = "HUMAN"
vim.g.switch_mapping = "-"
vim.g.dash_map = {
    vue = "javascript",
}
vim.g["tiler#layout"] = "bottom"
vim.g["tiler#popup#windows"] = {
    terminal = { position = "bottom", size = 10, filetype = "terminal", order = 3 },
    nerdtree = { position = "left", size = 10, filetype = "nerdtree", order = 2 },
    tagbar = { position = "right", size = 10, filetype = "tagbar", order = 1 },
}
vim.g.terminal_key = ""
vim.g.neoterm_default_mod = "botright"
vim.g.asynctasks_config_name = ".vim/tasks.ini"
vim.g.cmake_compile_commands = 1
vim.g.indentLine_setConceal = 0

vim.g.mapleader = " "
vim.g.maplocalleader = ","

vim.opt.backspace = { "indent", "eol", "start" }
vim.opt.number = true
vim.opt.wrap = false
vim.opt.incsearch = true
vim.opt.ignorecase = true
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true
vim.opt.timeoutlen = 500
vim.opt.cursorline = true
vim.opt.hidden = true
vim.opt.writebackup = false
vim.opt.updatetime = 300
vim.opt.shortmess:append("c")
vim.opt.signcolumn = "yes:3"
vim.opt.mouse = "nvi"
vim.opt.colorcolumn = { 80, 120 }
vim.opt.swapfile = false

if vim.fn.has("termguicolors") == 1 then
    vim.opt.termguicolors = true
end

api.nvim_create_user_command("Todo", function()
    vim.cmd("Rg #TODO")
end, {})

api.nvim_create_user_command("Note", function()
    vim.cmd("Rg #NOTE")
end, {})

api.nvim_create_user_command("HomePage", function()
    pcall(vim.fn["startify#insane_in_the_membrane"], 0)
end, {})

api.nvim_create_user_command("SourceCurrentFile", commands.source_current_file, {})

api.nvim_create_user_command("ChunkInfo", function()
    vim.cmd("CocCommand git.chunkInfo")
end, {})

api.nvim_create_user_command("ChuckStage", function()
    vim.cmd("CocCommand git.chunkStage")
end, {})

api.nvim_create_user_command("ChunkUndo", function()
    vim.cmd("CocCommand git.chunkUndo")
end, {})

api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("MynvimFormatOptions", { clear = true }),
    callback = function()
        vim.opt_local.formatoptions = "crqn2l1j"
    end,
})

api.nvim_create_autocmd("TermOpen", {
    group = api.nvim_create_augroup("MynvimTermOpen", { clear = true }),
    callback = function()
        vim.opt_local.sidescroll = 1
        vim.opt_local.sidescrolloff = 0
        vim.opt_local.number = false
    end,
})

api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("MynvimRooter", { clear = true }),
    callback = function()
        pcall(vim.cmd, "Rooter")
    end,
})

api.nvim_create_autocmd("User", {
    group = "MynvimRooter",
    pattern = "StartifyBufferOpened",
    callback = function()
        pcall(vim.cmd, "Rooter")
    end,
})

api.nvim_create_autocmd("BufEnter", {
    group = api.nvim_create_augroup("MynvimProjectLocal", { clear = true }),
    callback = commands.load_project_local_configs,
})

api.nvim_create_autocmd({ "WinEnter", "InsertLeave" }, {
    group = api.nvim_create_augroup("MynvimCursorline", { clear = true }),
    callback = function()
        vim.opt_local.cursorline = true
    end,
})

api.nvim_create_autocmd({ "WinLeave", "InsertEnter" }, {
    group = "MynvimCursorline",
    callback = function()
        vim.opt_local.cursorline = false
    end,
})

local function substitute_current(pattern)
    vim.cmd(("silent! s#%s#g"):format(pattern))
end

api.nvim_create_user_command("CamelCase", function(opts)
    local pattern = opts.range == 0
        and [[\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)#\u\1\2]]
        or [[\%V\(\%(\<\l\+\)\%(_\)\@=\)\|_\(\l\)\%V#\u\1\2]]
    substitute_current(pattern)
end, { range = true })

api.nvim_create_user_command("SnakeCase", function(opts)
    local pattern = opts.range == 0
        and [[\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)#\l\1_\l\2]]
        or [[\%V\C\(\<\u[a-z0-9]\+\|[a-z0-9]\+\)\(\u\)\%V#\l\1_\l\2]]
    substitute_current(pattern)
end, { range = true })

api.nvim_create_user_command("Rgx", function(opts)
    vim.fn["fzf#vim#grep"](
        "rg --column --line-number --no-heading --color=always --smart-case " .. opts.args,
        1,
        opts.bang and 1 or 0
    )
end, { bang = true, nargs = "*" })
