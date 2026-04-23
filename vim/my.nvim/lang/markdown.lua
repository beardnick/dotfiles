vim.g.vim_markdown_math = 1
vim.g.vim_markdown_toc_autofit = 1
vim.g.vim_markdown_fenced_languages = {
    "c++=cpp",
    "viml=vim",
    "bash=sh",
    "ini=dosini",
    "js=javascript",
    "json=javascript",
    "jsx=javascriptreact",
    "tsx=typescriptreact",
    "docker=Dockerfile",
    "makefile=make",
    "py=python",
}

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("MynvimMarkdownConceal", { clear = true }),
    pattern = { "markdown", "json" },
    callback = function()
        vim.opt_local.concealcursor = "c"
    end,
})
