local M = {}

function M.has_key (table,key)
    for k,v in pairs(table) do
        if k == key then
            return true
        end
    end
    return false
end

return M
