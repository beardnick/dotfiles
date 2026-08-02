local plug = require("plug")

if not plug.loaded("yanky.nvim") then
    return
end

require("yanky").setup({
    ring = { history_length = 100 },
    highlight = { on_put = false, on_yank = false },
})

if plug.loaded("telescope.nvim") then
    require("telescope").load_extension("yank_history")
end
