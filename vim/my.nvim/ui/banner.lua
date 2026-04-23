vim.g.startify_padding_left = 10

if vim.fn.exists("*startify#pad") == 1 then
    vim.g.startify_custom_header = vim.fn["startify#pad"](vim.g.mynvim_banner)
end
