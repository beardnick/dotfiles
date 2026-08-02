local plug = require("plug")

if not plug.loaded("blink.cmp") then
    return
end

-- same rule the old coc <Tab> binding used: only trigger completion after a word
local function has_words_before()
    local col = vim.fn.col(".") - 1
    return col > 0 and vim.fn.getline("."):sub(col, col):match("%s") == nil
end

-- accept the copilot ghost text when the completion menu is closed
local function accept_copilot(cmp)
    if cmp.is_visible() then
        return
    end
    local ok, suggestion = pcall(vim.fn["copilot#GetDisplayedSuggestion"])
    if not ok or not suggestion or suggestion.text == "" then
        return
    end
    vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](""), "i", true)
    return true
end

local sources = { "lsp", "path", "snippets", "buffer" }
local providers = {}

if plug.loaded("blink-cmp-tmux") then
    table.insert(sources, "tmux")
    providers.tmux = {
        module = "blink-cmp-tmux",
        name = "tmux",
        opts = {
            panes = "all",
            capture_history = false,
        },
    }
end

if plug.loaded("blink-cmp-dictionary") then
    table.insert(sources, "dictionary")
    providers.dictionary = {
        module = "blink-cmp-dictionary",
        name = "Dict",
        min_keyword_length = 3,
        opts = {
            -- vim-dict fills 'dictionary' per filetype, reuse its dict files
            dictionary_files = function()
                return vim.opt_local.dictionary:get()
            end,
        },
    }
end

require("blink.cmp").setup({
    keymap = {
        preset = "none",
        ["<Tab>"] = {
            accept_copilot,
            "select_next",
            "snippet_forward",
            function(cmp)
                if has_words_before() then
                    return cmp.show()
                end
            end,
            "fallback",
        },
        ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
        ["<C-n>"] = { "select_next", "show", "fallback" },
        ["<C-p>"] = { "select_prev", "fallback" },
        ["<CR>"] = { "accept", "fallback" },
        ["<C-e>"] = { "hide", "fallback" },
        ["<C-d>"] = { "scroll_documentation_down", "fallback" },
        ["<C-u>"] = { "scroll_documentation_up", "fallback" },
    },
    completion = {
        list = {
            selection = { preselect = true, auto_insert = false },
        },
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
        },
    },
    signature = { enabled = true },
    sources = {
        default = sources,
        providers = providers,
    },
})
