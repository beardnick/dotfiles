if not require("plug").loaded("dressing.nvim") then
    return
end

-- floating input for vim.ui.input (e.g. :Rename), telescope for vim.ui.select
require("dressing").setup({
    input = {
        insert_only = false,
        start_in_insert = true,
    },
})
