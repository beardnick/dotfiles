if not require("plug").loaded("nvim-tree.lua") then
    return
end

require("nvim-tree").setup({
    sync_root_with_cwd = true,
    respect_buf_cwd = true,
    update_focused_file = {
        enable = true,
    },
})
