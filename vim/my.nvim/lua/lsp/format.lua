local M = {}

---Synchronously run a code action of the given kind on the whole buffer.
---@param bufnr integer
---@param kind string e.g. "source.organizeImports"
---@param timeout_ms integer|nil
function M.code_action_sync(bufnr, kind, timeout_ms)
    local clients = vim.lsp.get_clients({ bufnr = bufnr, method = "textDocument/codeAction" })
    for _, client in ipairs(clients) do
        local params = vim.lsp.util.make_range_params(0, client.offset_encoding)
        params.context = { only = { kind }, diagnostics = {} }
        local resp = client:request_sync("textDocument/codeAction", params, timeout_ms or 1000, bufnr)
        for _, action in ipairs(resp and resp.result or {}) do
            if action.edit then
                vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
            elseif action.command then
                client:exec_cmd(action.command, { bufnr = bufnr })
            end
        end
    end
end

function M.organize_imports(bufnr)
    M.code_action_sync(bufnr or vim.api.nvim_get_current_buf(), "source.organizeImports")
end

---BufWritePre handler for Go: organize imports then format, like coc-go did
function M.go_on_save(bufnr)
    M.organize_imports(bufnr)
    vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
end

return M
