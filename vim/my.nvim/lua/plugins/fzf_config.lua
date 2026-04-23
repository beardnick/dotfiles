local loaded = require("plug").loaded

if not loaded("fzf.vim") then
    return
end

local map = vim.keymap.set

vim.g.fzf_buffers_jump = 1
vim.g.fzf_history_dir = "~/.local/share/fzf-history"
vim.env.FZF_DEFAULT_OPTS = "--layout=reverse"
vim.g.fzf_layout = { window = { width = 0.9, height = 0.6 } }

vim.api.nvim_create_user_command("Cheats", function(opts)
    vim.fn["fzf#vim#files"]("~/.cheat", vim.fn["fzf#vim#with_preview"](), opts.bang and 1 or 0)
end, { bang = true, nargs = "?", complete = "dir" })

vim.api.nvim_create_user_command("VMaps", function(opts)
    vim.fn["fzf#vim#maps"]("v", opts.bang and 1 or 0)
end, { bang = true })

vim.api.nvim_create_user_command("IMaps", function(opts)
    vim.fn["fzf#vim#maps"]("i", opts.bang and 1 or 0)
end, { bang = true })

if vim.fn.executable("rg") == 1 then
    vim.env.FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow --glob "!.git/*"'
    vim.opt.grepprg = "rg --vimgrep"
    vim.api.nvim_create_user_command("Find", function(opts)
        local command = 'rg --column --line-number --no-heading --fixed-strings --ignore-case --hidden --follow --glob "!.git/*" --color "always" '
            .. vim.fn.shellescape(opts.args)
            .. '| tr -d "\\017"'
        vim.fn["fzf#vim#grep"](command, 1, opts.bang and 1 or 0)
    end, { bang = true, nargs = "*" })
end

local function fzf_sink(what)
    local p1 = string.find(what, "<", 1, true)
    if not p1 then
        return
    end

    local name = vim.trim(string.sub(what, 1, p1 - 1))
    if name == "" then
        return
    end

    vim.cmd("AsyncTask " .. vim.fn.fnameescape(name))
end

local function fzf_task()
    local rows = vim.fn["asynctasks#source"](math.floor(vim.o.columns * 48 / 100))
    local source = {}

    for _, row in ipairs(rows) do
        source[#source + 1] = string.format("%s  %s  : %s", row[1], row[2], row[3])
    end

    local opts = {
        source = source,
        sink = fzf_sink,
        options = "+m --nth 1 --inline-info --tac",
    }

    if vim.g.fzf_layout then
        for key, value in pairs(vim.deepcopy(vim.g.fzf_layout)) do
            opts[key] = value
        end
    end

    vim.fn["fzf#run"](opts)
end

vim.api.nvim_create_user_command("AsyncTaskFzf", fzf_task, {})

if loaded("fzf-filemru") then
    map("n", "<C-p>", "<Cmd>FilesMru --tiebreak=index<CR>", { silent = true })
end
