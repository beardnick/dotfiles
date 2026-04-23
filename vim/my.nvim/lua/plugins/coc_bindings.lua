local loaded = require("plug").loaded

if not loaded("coc.nvim") then
    return
end

local api = vim.api
local map = vim.keymap.set

local function check_backspace()
    local col = vim.fn.col(".") - 1
    return col <= 0 or vim.fn.getline("."):sub(col, col):match("%s") ~= nil
end

api.nvim_create_autocmd("CursorHold", {
    group = api.nvim_create_augroup("MynvimCocCursorHold", { clear = true }),
    callback = function()
        pcall(vim.fn.CocActionAsync, "highlight")
    end,
})

map("i", "<C-n>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#next"](1)
    end
    if check_backspace() then
        return "<Tab>"
    end
    return vim.fn["coc#refresh"]()
end, { expr = true, silent = true, replace_keycodes = true })

map("i", "<C-p>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#prev"](1)
    end
    return "<C-h>"
end, { expr = true, silent = true, replace_keycodes = true })

map("i", "<Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#next"](1)
    end
    if check_backspace() then
        return "<Tab>"
    end
    return vim.fn["coc#refresh"]()
end, { expr = true, silent = true, replace_keycodes = true })

map("i", "<S-Tab>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#prev"](1)
    end
    return "<C-h>"
end, { expr = true, replace_keycodes = true })

map("i", "<CR>", function()
    if vim.fn["coc#pum#visible"]() == 1 then
        return vim.fn["coc#pum#confirm"]()
    end
    return "<C-g>u<CR><c-r>=coc#on_enter()<CR>"
end, { expr = true, silent = true, replace_keycodes = true })

api.nvim_create_autocmd("FileType", {
    group = api.nvim_create_augroup("MynvimCocFiletypes", { clear = true }),
    pattern = { "typescript", "json" },
    callback = function()
        vim.bo.formatexpr = "CocAction('formatSelected')"
    end,
})

api.nvim_create_autocmd("User", {
    group = "MynvimCocFiletypes",
    pattern = "CocJumpPlaceholder",
    callback = function()
        pcall(vim.fn.CocActionAsync, "showSignatureHelp")
    end,
})

api.nvim_create_autocmd("BufWritePre", {
    group = api.nvim_create_augroup("MynvimCocGo", { clear = true }),
    pattern = "*.go",
    callback = function()
        pcall(vim.fn.CocAction, "runCommand", "editor.action.organizeImport")
        pcall(vim.fn.CocAction, "format")
    end,
})

api.nvim_create_user_command("Refactor", function()
    vim.fn.CocActionAsync("refactor")
end, {})

api.nvim_create_user_command("Rename", function()
    vim.fn.CocActionAsync("rename")
end, {})

api.nvim_create_user_command("Format", function()
    vim.fn.CocAction("format")
end, {})

api.nvim_create_user_command("Fold", function(opts)
    vim.fn.CocAction("fold", opts.args)
end, { nargs = "?" })

map({ "n", "v" }, "K", function()
    vim.fn.CocActionAsync("definitionHover")
end, { silent = true })

map("n", "<C-d>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](1)
    end
    return "<C-d>"
end, { expr = true, nowait = true, replace_keycodes = true })

map("n", "<C-u>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
        return vim.fn["coc#float#scroll"](0)
    end
    return "<C-u>"
end, { expr = true, nowait = true, replace_keycodes = true })

map("i", "<C-d>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
        return '<c-r>=coc#float#scroll(1)<cr>'
    end
    return "<Right>"
end, { expr = true, nowait = true, replace_keycodes = true })

map("i", "<C-u>", function()
    if vim.fn["coc#float#has_scroll"]() == 1 then
        return '<c-r>=coc#float#scroll(0)<cr>'
    end
    return "<Left>"
end, { expr = true, nowait = true, replace_keycodes = true })

map("n", "gd", "<Plug>(coc-definition)", { silent = true })
map("n", "gr", "<Plug>(coc-references)", { silent = true })
map("n", "gi", "<Plug>(coc-implementation)", { silent = true })
map("n", "]c", "<Plug>(coc-git-nextchunk)", { silent = true })
map("n", "[c", "<Plug>(coc-git-prevchunk)", { silent = true })
map("n", "]e", "<Plug>(coc-diagnostic-next-error)", { silent = true })
map("n", "[e", "<Plug>(coc-diagnostic-prev-error)", { silent = true })
map("n", "]w", "<Plug>(coc-diagnostic-next)", { silent = true })
map("n", "[w", "<Plug>(coc-diagnostic-prev)", { silent = true })
map("n", "<Leader>t", "<Plug>(coc-translator-p)", { silent = true })
map("v", "<Leader>t", "<Plug>(coc-translator-pv)", { silent = true })
map("n", "<Leader>sw", "<Cmd>CocList translators<CR>", { silent = true })
