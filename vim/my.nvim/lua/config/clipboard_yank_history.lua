local M = {}

function M.setup(enabled)
    local group = vim.api.nvim_create_augroup("MynvimClipboardYankHistory", { clear = true })
    if not enabled then
        return
    end
    vim.api.nvim_create_autocmd("TextYankPost", {
        group = group,
        callback = function()
            local event = vim.v.event
            if event.regname ~= "+" and event.regname ~= "*" then
                return
            end
            -- The event already contains what was copied. Reading +/* here
            -- would query the terminal again and can block on OSC 52 paste.
            local contents = table.concat(event.regcontents, "\n")
            if event.regtype == "V" then
                contents = contents .. "\n"
            end
            require("yanky.history").push({
                regcontents = contents,
                regtype = event.regtype,
                filetype = vim.bo.filetype,
            })
        end,
    })
end

return M
