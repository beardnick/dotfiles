if not require 'plug'.loaded('orgmode') then
    return
end

require('orgmode').setup({
    org_todo_keywords = { 'TODO', 'DONE', 'WAITING', '|', 'DELEGATED', 'CANCEL' },
    mappings = {
        prefix = '<LocalLeader>',
        --prefix = ',o',
        org = {
            org_toggle_checkbox = '<prefix>cc',
        }
    }
})
-- modern nvim-orgmode ships and installs its own org parser, the old
-- setup_ts_grammar() + nvim-treesitter.configs coupling is gone

vim.cmd [[highlight default link OrgTODO Todo]]
