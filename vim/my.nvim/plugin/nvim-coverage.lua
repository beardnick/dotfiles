if not require 'plug'.loaded('nvim-coverage') then
    return
end

require("coverage").setup()
