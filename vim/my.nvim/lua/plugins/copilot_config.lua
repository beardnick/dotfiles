if not require("plug").loaded("copilot.vim") then
    return
end

-- Tab belongs to blink.cmp; accept copilot suggestions with dedicated keys
vim.g.copilot_no_tab_map = true

local map = vim.keymap.set
local opts = { expr = true, replace_keycodes = false, silent = true }

-- accept the whole suggestion
map("i", "<C-l>", 'copilot#Accept("")', opts)
-- accept only the next word / line
map("i", "<M-l>", "<Plug>(copilot-accept-word)")
map("i", "<M-j>", "<Plug>(copilot-accept-line)")
-- cycle through alternative suggestions
map("i", "<M-]>", "<Plug>(copilot-next)")
map("i", "<M-[>", "<Plug>(copilot-previous)")
