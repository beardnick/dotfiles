if not require('plug').loaded('AutoSave.nvim') then
    return
end

require'autosave'.setup {
    enabled= true,
    execution_message = "",
}
