local plug = require('plug')

if not plug.loaded('nvim-treesitter') then
    return
end

-- languages whose buffers get treesitter highlighting (same set the old
-- master-branch ensure_installed covered)
local highlight_langs = {
    c = true,
    cpp = true,
    go = true,
    java = true,
    javascript = true,
    lua = true,
    rust = true,
}

-- markdown parsers are installed on top so LSP hover floats can render
-- fenced code blocks, but markdown buffers keep their regex syntax
local install_langs = { "c", "cpp", "go", "java", "javascript", "lua", "rust", "markdown", "markdown_inline" }

-- parser compilation needs the tree-sitter cli (mason installs it); skip
-- quietly on the boot where it is not there yet, next boot picks it up
if vim.fn.executable('tree-sitter') == 1 then
    require('nvim-treesitter').install(install_langs)
end

vim.api.nvim_create_autocmd('FileType', {
    group = vim.api.nvim_create_augroup('MynvimTreesitterStart', { clear = true }),
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang and highlight_langs[lang] then
            pcall(vim.treesitter.start, args.buf, lang)
        end
    end,
})

if plug.loaded('nvim-treesitter-textobjects') then
    require('nvim-treesitter-textobjects').setup({
        select = { lookahead = true },
    })

    local function select_textobject(query)
        return function()
            require('nvim-treesitter-textobjects.select').select_textobject(query, 'textobjects')
        end
    end

    vim.keymap.set({ 'x', 'o' }, 'af', select_textobject('@function.outer'), { silent = true })
    vim.keymap.set({ 'x', 'o' }, 'if', select_textobject('@function.inner'), { silent = true })
end

local treesitter = require('treesitter')

-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1424
-- https://github.com/neovim/neovim/issues/14977
-- neovim fold doesn't work sometimes, just take :e % as a workaround
vim.o.foldmethod = 'expr'
vim.o.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
vim.o.foldlevelstart = 99
