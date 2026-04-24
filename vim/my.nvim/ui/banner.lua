vim.g.startify_padding_left = 10

if type(vim.g.mynvim_banner) == "table" then
    local padding = string.rep(" ", vim.g.startify_padding_left or 0)
    vim.g.startify_custom_header = vim.tbl_map(function(line)
        return padding .. line
    end, vim.g.mynvim_banner)
end
