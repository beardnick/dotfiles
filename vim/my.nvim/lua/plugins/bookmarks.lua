local plug = require("plug")

if plug.loaded("vim-bookmarks") then
    vim.g.bookmark_save_per_working_dir = 1
    vim.g.bookmark_save_relative_dir = 1
    vim.fn["bm#setup"]()
end
