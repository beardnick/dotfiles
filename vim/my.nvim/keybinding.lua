local commands = require("config.commands")

local map = vim.keymap.set
local silent = { silent = true }

local function command_map(lhs, rhs, modes, opts)
    map(modes or "n", lhs, "<Cmd>" .. rhs .. "<CR>", opts or silent)
end

-- like coc-fix-current: apply the quickfix action for the diagnostic under cursor
local function fix_current()
    vim.lsp.buf.code_action({ context = { only = { "quickfix" } }, apply = true })
end

local function next_uncommented_block(direction)
    local next_match = vim.fn.line(".")
    local last_match = next_match - direction

    while last_match == next_match - direction do
        last_match = next_match
        if direction == 1 then
            next_match = vim.fn.search("^\\s*[^ #]", "e")
        else
            next_match = vim.fn.search("^\\s*[^ #]", "be")
        end
    end

    vim.fn.cursor(next_match, vim.fn.col("."))
end

vim.g.mapleader = " "
vim.g.maplocalleader = ","

map("n", "<Leader>/", [[:<C-U>FzfPreviewLines <C-R><C-W><CR>]], silent)
map("n", "<C-F>", [[:<C-U>Rg <C-R><C-W><CR>]], silent)
map("n", "<Leader><Leader>", [[:<C-U>Commands<CR><C-P>]], silent)
command_map("<C-G>", "Note")
command_map("<C-L>", "nohlsearch")

map("n", "<Leader>w", "<C-W>")
map("i", "jk", "<Esc>")
map("i", "jj", "<Esc>")
map("i", "kk", "<Esc>")

map("v", "<Leader>s", "<Plug>VSurround")
map("n", "<Leader>s", "<Plug>Ysurround")
command_map("<C-J>", "Snippets")
map("v", "<", "<gv")
map("v", ">", ">gv")

map("n", "<Leader>;", [[:<C-U>call nerdcommenter#Comment("n", "Toggle")<CR>]], silent)
map("v", "<Leader>;", [[:call nerdcommenter#Comment("x", "Toggle")<CR>gv]], silent)
map("n", "<C-_>", [[:<C-U>call nerdcommenter#Comment("n", "Toggle")<CR>]], silent)
map("v", "<C-_>", [[:call nerdcommenter#Comment("x", "Toggle")<CR>gv]], silent)

map("v", "<C-v>", '"+p')
map("v", "<Leader>yy", '"+y')
map("v", "<Leader>ya", '"ay')
map("v", "<Leader>yb", '"by')
map("v", "<Leader>yc", '"cy')

map("n", "<Leader>pp", 'viw"+p')
map("n", "<Leader>pa", 'viw"ap')
map("n", "<Leader>pb", 'viw"bp')
map("n", "<Leader>pc", 'viw"cp')
map("v", "<Leader>pp", '"+p')
map("v", "<Leader>pa", '"ap')
map("v", "<Leader>pb", '"bp')
map("v", "<Leader>pc", '"cp')

map("v", "<Leader>rr", '"+p')
map("v", "<Leader>ra", '"ap')
map("v", "<Leader>rb", '"bp')
map("v", "<Leader>rc", '"cp')
map("n", "<Leader>rr", 'viw"+p')
map("n", "<Leader>ra", 'viw"ap')
map("n", "<Leader>rb", 'viw"bp')
map("n", "<Leader>rc", 'viw"cp')
command_map("<C-Y>", "Telescope yank_history")

command_map("<Leader>gi", "ChunkInfo")
command_map("<Leader>gu", "ChunkUndo")
command_map("<Leader>gb", "Gblame")

for i = 1, 8 do
    command_map("<A-" .. i .. ">", "BufferGoto " .. i)
end

for i = 1, 9 do
    command_map("<Leader>b" .. i, "BufferGoto " .. i)
end

command_map("<Leader>bh", "HomePage")
command_map("<Leader>bn", "bnext")
command_map("<Leader>bp", "bprevious")
command_map("<Leader>bd", "bdelete")
command_map("<Leader>bl", "blast")
command_map("<Leader>bf", "bfirst")
command_map("<Leader>bt", "BTags")
command_map("<Leader>bs", "Buffers")
map("n", "<Leader>bv", commands.buffer_split_vertical, silent)

command_map("<Leader>lf", "Format", { "n", "v" })
map({ "n", "x" }, "<Leader>lc", fix_current, silent)
command_map("<Leader>lr", "AsyncTask file-run")
command_map("<Leader>lp", "AsyncTask project-run")
command_map("<Leader>lg", "TemplateHere")
command_map("<Leader>lt", "AsyncTaskFzf")

command_map("<Leader>ft", "NvimTreeToggle")

command_map("<Leader>hm", "Maps")
command_map("<Leader>hc", "Cheats")
map("n", "<Leader>hd", "<Plug>DashSearch", silent)

map("n", "<Leader>uw", function()
    vim.wo.wrap = not vim.wo.wrap
end, silent)
command_map("<Leader>ut", "Vista!!")
map("n", "<Leader>un", function()
    vim.wo.number = not vim.wo.number
end, silent)
map("n", "<Leader>ui", function()
    local enabled = vim.lsp.inlay_hint.is_enabled({ bufnr = 0 })
    vim.lsp.inlay_hint.enable(not enabled, { bufnr = 0 })
end, silent)
command_map("<Leader>up", "Goyo")
map("n", "<Leader>uh", function()
    vim.opt_local.concealcursor = "c"
end, silent)
command_map("<Leader>ug", "ChunkInfo")
map("n", "<Leader>ub", commands.toggle_background, silent)

command_map("<Leader>w+", "5wincmd +")
command_map("<Leader>w-", "5wincmd -")
command_map("<Leader>w<", "5wincmd <")
command_map("<Leader>w>", "5wincmd >")
map("n", "<Leader>wc", "<Plug>(choosewin)")
command_map("<Leader>wm", "MaximizerToggle", { "n", "v" }, silent)
map("i", "<Leader>wm", "<C-o>:MaximizerToggle<CR>", silent)

map("n", "<Leader>cq", fix_current, silent)
map({ "n", "x" }, "<Leader>ca", vim.lsp.buf.code_action, silent)
map("n", "<Leader>co", function()
    require("lsp.format").organize_imports()
end, silent)

command_map("<M-.>", "5wincmd >")
command_map("<M-,>", "5wincmd <")
command_map("<M-=>", "5wincmd +")
command_map("<M-->", "5wincmd -")

command_map("<Leader>sr", "Rg")
map("n", "<Leader>sg", [[:<C-U>FzfPreviewProjectGrep ""<CR>]])
command_map("<Leader>sl", "FzfPreviewLines")
command_map("<Leader>st", "Tags")
command_map("<Leader>sf", "Files")
command_map("<Leader>sb", "FzfPreviewBuffers")
map("t", "<Leader>sb", [[<C-\><C-n>:<C-U>FzfPreviewBuffers<CR>]])
command_map("<Leader>se", "Telescope diagnostics")
command_map("<Leader>sh", "History:")

map("v", "<Leader>e", ":Expand<CR>")

command_map("<Leader>rp", "MirrorPush")
command_map("<Leader>rl", "MirrorPull")
map("v", "<C-E>", ":normal @q<CR>")
map("n", "<C-E>", ":normal @q<CR>")
map("n", "<C-Q>", commands.toggle_recording, silent)

map("n", "[g", function()
    vim.diagnostic.jump({ count = -1, float = true })
end, silent)
map("n", "]g", function()
    vim.diagnostic.jump({ count = 1, float = true })
end, silent)
map({ "n", "x" }, "<leader>a", vim.lsp.buf.code_action, silent)
map("n", "<leader>ac", vim.lsp.buf.code_action, silent)
map("n", "<leader>qf", fix_current, silent)
-- if/af function textobjects are provided by nvim-treesitter-textobjects

map("n", "Y", "y$")
map("c", "<C-a>", "<Home>")
map("c", "<C-e>", "<End>")

map("n", "<leader>sv", function()
    require("setup").setup()
end, silent)
command_map("<leader>ev", "edit $MYVIMRC")

map("n", "]]", function()
    next_uncommented_block(1)
end, silent)
map("n", "[[", function()
    next_uncommented_block(-1)
end, silent)
