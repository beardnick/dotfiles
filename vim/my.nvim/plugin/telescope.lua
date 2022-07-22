local loaded = require'plug'.loaded
local map =vim.api.nvim_set_keymap
local mapopt = {noremap = true, silent = true}

if not loaded('telescope.nvim') then
    return
end

local extensions = {}

if loaded('telescope-fzf-native.nvim') then
    require('telescope').load_extension('fzf')
    extensions.fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
    }
end

if loaded('telescope-fzy-native.nvim') then
    require('telescope').load_extension('fzy_native')
end

require'telescope'.load_extension('goimpl')
vim.api.nvim_create_user_command('Goimpl','Telescope goimpl',{})

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
   extensions = extensions,
}



--map('n','<leader>sr',[[<cmd>Telescope grep_string search="" only_sort_text=true<cr>]],mapopt)
--map('n','<C-p>',[[<cmd>Telescope find_files<cr>]],mapopt)
map('n','<C-h>',[[<cmd>Telescope help_tags<cr>]],mapopt)
-- telescope commands missed call s:func commands compared with fzf
--map('n','<leader><leader>',[[<cmd>Telescope commands<cr>]],mapopt)

if loaded('telescope-coc.nvim') then
    require('telescope').load_extension('coc')
    map('n','gr',[[<cmd>Telescope coc references<cr>]],mapopt)
    map('n','gd',[[<cmd>Telescope coc definitions<cr>]],mapopt)
    map('n','gi',[[<cmd>Telescope coc implementations<cr>]],mapopt)
    -- https://vimhelp.org/vim_faq.txt.html#faq-20.5 only Ctrl-printable-key can be safely mapped
    map('n','<C-\\>',[[<cmd>Telescope coc code_actions<cr>]],mapopt)
    map('i','<C-\\>',[[<cmd>Telescope coc code_actions<cr>]],mapopt)
end

-- better telescope highlights
local colors = {
   white = "#abb2bf",
   darker_black = "#1b1f27",
   black = "#1e222a", --  nvim bg
   black2 = "#252931",
   one_bg = "#282c34", -- real bg of onedark
   one_bg2 = "#353b45",
   one_bg3 = "#30343c",
   grey = "#42464e",
   grey_fg = "#565c64",
   grey_fg2 = "#6f737b",
   light_grey = "#6f737b",
   red = "#d47d85",
   baby_pink = "#DE8C92",
   pink = "#ff75a0",
   line = "#2a2e36", -- for lines like vertsplit
   green = "#A3BE8C",
   vibrant_green = "#7eca9c",
   nord_blue = "#81A1C1",
   blue = "#61afef",
   yellow = "#e7c787",
   sun = "#EBCB8B",
   purple = "#b4bbc8",
   dark_purple = "#c882e7",
   teal = "#519ABA",
   orange = "#fca2aa",
   cyan = "#a3b8ef",
   statusline_bg = "#22262e",
   lightbg = "#2d3139",
   lightbg2 = "#262a32",
   pmenu_bg = "#A3BE8C",
   folder_bg = "#61afef",
}


local cmd = vim.cmd
local fg_bg =  function(group, fgcol, bgcol)
   cmd("hi " .. group .. " guifg=" .. fgcol .. " guibg=" .. bgcol)
end

local bg = function(group, col)
   cmd("hi " .. group .. " guibg=" .. col)
end

fg_bg("TelescopeBorder", colors.darker_black, colors.darker_black)
fg_bg("TelescopePromptBorder", colors.black2, colors.black2)

fg_bg("TelescopePromptNormal", colors.white, colors.black2)
fg_bg("TelescopePromptPrefix", colors.red, colors.black2)

bg("TelescopeNormal", colors.darker_black)

fg_bg("TelescopePreviewTitle", colors.black, colors.green)
fg_bg("TelescopePromptTitle", colors.black, colors.red)
fg_bg("TelescopeResultsTitle", colors.darker_black, colors.darker_black)

bg("TelescopeSelection", colors.black2)

