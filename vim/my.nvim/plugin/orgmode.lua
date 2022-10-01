if not require 'plug'.loaded('orgmode') then
    return
end

require('orgmode').setup({
    org_todo_keywords = { 'TODO', 'WAITING', '|', 'DONE', 'DELEGATED','CANCEL' },
    mappings = {
        prefix = '<LocalLeader>',
        --prefix = ',o',
        org = {
            org_toggle_checkbox = '<prefix>cc',
        }
    }
})
require('orgmode').setup_ts_grammar()

require 'nvim-treesitter.configs'.setup {
    -- If TS highlights are not enabled at all, or disabled via `disable` prop, highlighting will fallback to default Vim syntax highlighting
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = { 'org' }, -- Required for spellcheck, some LaTex highlights and code block highlights that do not have ts grammar
    },
    ensure_installed = { 'org' }, -- Or run :TSUpdate org
}

vim.cmd [[highlight default link OrgTODO Todo]]
