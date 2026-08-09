local plug = require("plug")

if not plug.loaded("blink.cmp") then
    return
end

-- Tab is dedicated to the copilot ghost text; menu selection uses the
-- arrow keys, so the two never fight over the same key
local function accept_copilot(cmp)
    local ok, suggestion = pcall(vim.fn["copilot#GetDisplayedSuggestion"])
    if not ok or not suggestion or suggestion.text == "" then
        return
    end
    if cmp.is_visible() then
        cmp.hide()
    end
    -- Accept() returns an already-termcoded key sequence: escape_ks must
    -- be false or the <Cmd> bytes get double-escaped into garbage
    vim.api.nvim_feedkeys(vim.fn["copilot#Accept"](""), "i", false)
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
        ["<Tab>"] = { accept_copilot, "snippet_forward", "fallback" },
        ["<S-Tab>"] = { "snippet_backward", "fallback" },
        ["<Down>"] = { "select_next", "fallback" },
        ["<Up>"] = { "select_prev", "fallback" },
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
