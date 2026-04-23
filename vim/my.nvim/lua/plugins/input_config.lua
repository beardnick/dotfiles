vim.api.nvim_create_autocmd("User", {
    group = vim.api.nvim_create_augroup("MynvimInput", { clear = true }),
    pattern = "ZFVimIM_event_OnDbInit",
    callback = function()
        local db = vim.fn["ZFVimIM_dbInit"]({
            name = "YourDb",
        })

        vim.fn["ZFVimIM_cloudRegister"]({
            mode = "local",
            dbId = db.dbId,
            repoPath = vim.g.mynvim_root_path,
            dbFile = "/pinyin_huge.txt",
            dbCountFile = "/pinyin_huge_count.txt",
        })
    end,
})
