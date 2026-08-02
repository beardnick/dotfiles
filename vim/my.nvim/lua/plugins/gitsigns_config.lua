if not require("plug").loaded("gitsigns.nvim") then
    return
end

local map = vim.keymap.set

require("gitsigns").setup({
    current_line_blame = true,
    current_line_blame_opts = {
        delay = 300,
        virt_text_pos = "eol",
    },
    current_line_blame_formatter = ">>>  <author>, <author_time:%Y-%m-%d> · <summary>",
    on_attach = function(bufnr)
        local gs = require("gitsigns")
        local opts = { silent = true, buffer = bufnr }

        map("n", "]c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "]c", bang = true })
            else
                gs.nav_hunk("next")
            end
        end, opts)

        map("n", "[c", function()
            if vim.wo.diff then
                vim.cmd.normal({ "[c", bang = true })
            else
                gs.nav_hunk("prev")
            end
        end, opts)
    end,
})
