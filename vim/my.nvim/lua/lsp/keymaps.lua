local api = vim.api
local map = vim.keymap.set

local M = {}

local function find_float_win()
    for _, win in ipairs(api.nvim_tabpage_list_wins(0)) do
        if api.nvim_win_get_config(win).relative ~= "" then
            return win
        end
    end
end

---Scroll the first floating window (hover/signature docs), like coc#float#scroll
---@param down boolean
---@return boolean scrolled
function M.scroll_float(down)
    local win = find_float_win()
    if not win then
        return false
    end
    api.nvim_win_call(win, function()
        local key = down and "<C-d>" or "<C-u>"
        vim.cmd(("normal! %s"):format(api.nvim_replace_termcodes(key, true, false, true)))
    end)
    return true
end

local function diagnostic_jump(count, severity)
    return function()
        vim.diagnostic.jump({ count = count, float = true, severity = severity })
    end
end

local function telescope_or(builtin, fallback)
    return function()
        local ok, pickers = pcall(require, "telescope.builtin")
        if ok then
            pickers[builtin]()
        else
            fallback()
        end
    end
end

function M.setup_global()
    local error_sev = vim.diagnostic.severity.ERROR

    map("n", "]w", diagnostic_jump(1), { silent = true, desc = "Next diagnostic" })
    map("n", "[w", diagnostic_jump(-1), { silent = true, desc = "Prev diagnostic" })
    map("n", "]e", diagnostic_jump(1, error_sev), { silent = true, desc = "Next error" })
    map("n", "[e", diagnostic_jump(-1, error_sev), { silent = true, desc = "Prev error" })

    local function scroll_or_feed(down, key)
        return function()
            if not M.scroll_float(down) then
                local termcodes = api.nvim_replace_termcodes(key, true, false, true)
                api.nvim_feedkeys(termcodes, "n", false)
            end
        end
    end

    map("n", "<C-d>", scroll_or_feed(true, "<C-d>"), { nowait = true, silent = true })
    map("n", "<C-u>", scroll_or_feed(false, "<C-u>"), { nowait = true, silent = true })
end

---@param client vim.lsp.Client
---@param bufnr integer
function M.on_attach(client, bufnr)
    local opts = { silent = true, buffer = bufnr }

    map("n", "gd", vim.lsp.buf.definition, opts)
    map("n", "gr", telescope_or("lsp_references", vim.lsp.buf.references), opts)
    map("n", "gi", telescope_or("lsp_implementations", vim.lsp.buf.implementation), opts)
    map({ "n", "v" }, "K", vim.lsp.buf.hover, opts)

    if client:supports_method("textDocument/documentHighlight") then
        local group = api.nvim_create_augroup("MynvimLspHighlight" .. bufnr, { clear = true })
        api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.document_highlight()
            end,
        })
        api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.clear_references()
            end,
        })
    end

    if client:supports_method("textDocument/inlayHint") then
        vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
    end

    if client:supports_method("textDocument/codeLens") then
        local group = api.nvim_create_augroup("MynvimLspCodeLens" .. bufnr, { clear = true })
        api.nvim_create_autocmd({ "BufEnter", "InsertLeave", "BufWritePost" }, {
            group = group,
            buffer = bufnr,
            callback = function()
                vim.lsp.codelens.refresh({ bufnr = bufnr })
            end,
        })
    end
end

return M
