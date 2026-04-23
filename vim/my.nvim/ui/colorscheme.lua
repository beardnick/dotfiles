local colorscheme = vim.g.mynvim_colorscheme

if type(colorscheme) == "table" then
    vim.cmd.colorscheme(colorscheme.color)
else
    vim.cmd.colorscheme(colorscheme)
end

if vim.g.mynvim_colorscheme_backgroud == "auto" then
    local hour = tonumber(os.date("%H"))
    vim.o.background = (hour >= 18 or hour <= 7) and "dark" or "light"
else
    vim.o.background = vim.g.mynvim_colorscheme_backgroud
end

vim.g.lightline = {
    active = {
        left = {
            { "mode", "paste" },
            { "readonly", "absolutepath", "method", "modified", "filetype" },
        },
        right = {
            { "line", "percent" },
        },
    },
    component_function = {
        blame = "v:lua.LightlineGitBlame",
    },
}

if type(colorscheme) == "table" then
    vim.g.lightline.colorscheme = colorscheme.status
else
    vim.g.lightline.colorscheme = colorscheme
end

function _G.LightlineGitBlame()
    local blame = vim.b.coc_git_blame or ""
    return vim.fn.winwidth(0) > 120 and blame or ""
end

vim.api.nvim_set_hl(0, "CocHighlightText", { link = "MatchParen" })
vim.api.nvim_set_hl(0, "CocUnusedHighlight", { link = "MatchParen" })

vim.g.rainbow_active = 1
vim.g.gitgutter_enabled = 1

vim.opt.fillchars:append({ vert = "│" })
vim.cmd("hi VertSplit ctermbg=NONE guibg=NONE")
