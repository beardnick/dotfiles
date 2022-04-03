if not require('plug').loaded('lualine.nvim') then
    return
end


if  require('plug').loaded('nvim-gps') then

local gps = require("nvim-gps")

require("nvim-gps").setup()
require("lualine").setup({
	sections = {
            lualine_a = {'mode'},
            lualine_b = {'branch', 'diff', 'diagnostics'},
            lualine_c = {
                    'filename',
                    { gps.get_location, cond = gps.is_available },
                },
            lualine_x = {},
            lualine_y = {},
            lualine_z = {}
	}
})
end

