vim.g.gutentags_project_root = {
    ".root",
    ".svn",
    ".git",
    ".hg",
    ".project",
    "go.mod",
    "README",
    "README.md",
    ".gitignore",
}
vim.g.gutentags_ctags_tagfile = ".tags"
vim.g.gutentags_ctags_exclude = { "*.json" }
vim.g.gutentags_cache_dir = vim.fn.expand("~/.cache/tags")
vim.g.gutentags_ctags_extra_args = {
    "--fields=+niazS",
    "--extra=+q",
    "--c++-kinds=+px",
    "--c-kinds=+px",
}
vim.g.vista_default_executive = "ctags"

vim.fn.mkdir(vim.g.gutentags_cache_dir, "p")
