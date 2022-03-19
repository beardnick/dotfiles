local loaded = require'plug'.loaded
local map =vim.api.nvim_set_keymap
local mapopt = {noremap = true, silent = true}

if not loaded('telescope.nvim') then
    return
end

if loaded('telescope-fzy-native.nvim') then
    require('telescope').load_extension('fzy_native')
end

require('telescope').setup{
  defaults = {
    prompt_prefix = "   ",
      vimgrep_arguments = {
     "rg",
     "--color=never",
     "--no-heading",
     "--with-filename",
     "--line-number",
     "--column",
  },
   extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
    -- Default configuration for telescope goes here:
    -- config_key = value,
    mappings = {
      i = {
        -- map actions.which_key to <C-h> (default: <C-/>)
        -- actions.which_key shows the mappings for your picker,
        -- e.g. git_{create, delete, ...}_branch for the git_branches picker
        ["<Esc>"] = "close",
        ["<C-h>"] = "which_key",
        ["<C-j>"] = "move_selection_next",
        ["<C-k>"] = "move_selection_previous"
      }
    },
    sorting_strategy = "ascending", -- best match on top
    layout_strategy = "horizontal", -- select horizontal layout_strategy in layout_config
    layout_config = {
         horizontal = {
            prompt_position = "top", -- prompt on top
            preview_width = 0.55,
            results_width = 0.8,
         }
      },
  },
   extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  },
}

if loaded('telescope-fzf-native.nvim') then
    require('telescope').load_extension('fzf')
end


map('n','<leader>sr',[[<cmd>Telescope grep_string search="" only_sort_text=true<cr>]],mapopt)
map('n','<C-p>',[[<cmd>Telescope find_files<cr>]],mapopt)
map('n','<C-h>',[[<cmd>Telescope help_tags<cr>]],mapopt)

if loaded('telescope-coc.nvim') then
    require('telescope').load_extension('coc')
    map('n','gr',[[<cmd>Telescope coc references<cr>]],mapopt)
    map('n','gd',[[<cmd>Telescope coc definitions<cr>]],mapopt)
    map('n','gi',[[<cmd>Telescope coc implementations<cr>]],mapopt)
    -- https://vimhelp.org/vim_faq.txt.html#faq-20.5 only Ctrl-printable-key can be safely mapped
    map('n','<C-\\>',[[<cmd>Telescope coc code_actions<cr>]],mapopt)
    map('i','<C-\\>',[[<cmd>Telescope coc code_actions<cr>]],mapopt)
end



--local cmd = vim.cmd
--local fg_bg =  function(group, fgcol, bgcol)
--   cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
--end

--local bg = function(group, col)
--   cmd("hi " .. group .. " guibg=" .. col)
--end

--requires'hl_themes.ondeark'


--fg_bg("TelescopeBorder", darker_black, darker_black)
--fg_bg("TelescopePromptBorder", black2, black2)

--fg_bg("TelescopePromptNormal", white, black2)
--fg_bg("TelescopePromptPrefix", red, black2)

--bg("TelescopeNormal", darker_black)

--fg_bg("TelescopePreviewTitle", black, green)
--fg_bg("TelescopePromptTitle", black, red)
--fg_bg("TelescopeResultsTitle", darker_black, darker_black)

--bg("TelescopeSelection", black2)
