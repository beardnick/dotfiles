local M = {}

function M.join(slice, sep)
    local result = ""
    for k, v in pairs(slice) do
        if k == #slice then
            result = result .. v
            break
        end
        result = result .. v .. sep
    end
    return result
end

return M
