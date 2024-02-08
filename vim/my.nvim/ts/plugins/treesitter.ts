import * as plug from "../plug";

let map = vim.keymap.set;
let mapopt = { noremap: true, silent: true };

if (plug.loaded("nvim-treesitter")) {
  setupTreesitter();
}


function setupTreesitter() {
  import * as treesitter_config from "nvim-treesitter.configs";
  treesitter_config.setup(
    {
      // One of "all", "maintained" (parsers with maintainers), or a list of languages
      ensure_installed: ["go", "c", "cpp", "rust", "java", "javascript", "typescript", "lua"],
      //ensure_installed : "maintained",

      // Install languages synchronously (only applied to `ensure_installed`)
      sync_install: false,

      // List of parsers to ignore installing
      // ignore_install : { "javascript" },

      highlight: {
        // `false` will disable the whole extension
        enable: true,

        // Setting this to true will run `:h syntax` and tree-sitter at the same time.
        // Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
        // Using this option may slow down your editor, and you may see some duplicate highlights.
        // Instead of true it can also be a list of languages
        additional_vim_regex_highlighting: false,
      },

      playground: {
        enable: true,
        disable: {},
        updatetime: 25, // Debounced time for highlighting nodes in the playground from source code
        persist_queries: false, // Whether the query persists across vim sessions
        keybindings: {
          toggle_query_editor: 'o',
          toggle_hl_groups: 'i',
          toggle_injected_languages: 't',
          toggle_anonymous_nodes: 'a',
          toggle_language_display: 'I',
          focus_language: 'f',
          unfocus_language: 'F',
          update: 'R',
          goto_node: '<cr>',
          show_help: '?',
        },
      },
    }
  );
  vim.o.foldmethod = "expr"
  vim.o.foldexpr = "nvim_treesitter#foldexpr()"
  vim.o.foldlevelstart = 99
}
