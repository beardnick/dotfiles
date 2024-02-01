import * as plug from "../plug";

let map = vim.keymap.set;
let mapopt = { noremap: true, silent: true };

if (plug.loaded("nvim-lspconfig")) {
  setupLsp();
}

if (plug.loaded("none-ls.nvim")) {
  setupNullLs();
}

if (plug.loaded("nvim-cmp")) {
  setupCmp();
}

//if (plug.loaded("nvim-lsputils")) {
setupLspUtils();
//}

if (plug.loaded("renamer.nvim")) {
  import * as renamer from "renamer";
  renamer.setup();
  map("n", "<leader>rn", renamer.rename, mapopt);
}

function setupLsp() {
  import * as lspconfig from "lspconfig";
  import * as nvim_semantic_tokens from "nvim-semantic-tokens";
  import * as highlighters from "nvim-semantic-tokens.table-highlighter";
  import * as mason from "mason";
  import * as mason_lspconfig from "mason-lspconfig";
  import * as fidget from "fidget";

  fidget.setup();
  mason.setup();
  mason_lspconfig.setup(
    {
      ensure_installed: [
        "lua_ls",
        "rust_analyzer",
        "gopls",
        "zls",
        "typescript-language-server",
        "vim-language-server",
        "bash-language-server",
      ],
    }
  );

  nvim_semantic_tokens.setup(
    {
      preset: "default",
      highlighters: highlighters,
    }
  );
  lspconfig.lua_ls.setup({});
  lspconfig.tsserver.setup({});
  lspconfig.gopls.setup({
    settings: {
      gopls: {
        hints: {
          assignVariableTypes: true,
          compositeLiteralFields: true,
          compositeLiteralTypes: true,
          constantValues: true,
          functionTypeParameters: true,
          parameterNames: true,
          rangeVariableTypes: true,
        },
        semanticTokens: true,
      }
    }
  });

  //vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

  map('n', ']e', vim.diagnostic.goto_next, mapopt);
  map('n', '[e', vim.diagnostic.goto_prev, mapopt);
  map('n', '<leader>e', vim.diagnostic.open_float, mapopt);

  vim.api.nvim_create_autocmd("LspAttach", {
    group: vim.api.nvim_create_augroup("UserLspConfig", {}),
    callback: onLspAttach,
  });
}

function onLspAttach() {
  vim.lsp.inlay_hint.enable(0, true);
  map("n", "gD", vim.lsp.buf.declaration, mapopt);
  map("n", "gd", vim.lsp.buf.definition, mapopt);
  map('n', 'gr', vim.lsp.buf.references, mapopt);
  map("n", "K", vim.lsp.buf.hover, mapopt);
  map("n", "gi", vim.lsp.buf.implementation, mapopt);
  map("n", "<C-k>", vim.lsp.buf.signature_help, mapopt);
  map("n", `<C-\\>`, vim.lsp.buf.code_action, mapopt);
  //map("n", "<leader>rn", vim.lsp.buf.rename, mapopt);
  map("n", "<leader>lf", () => vim.lsp.buf.format({ async: true }), mapopt);
}

function setupCmp() {
  import * as cmp from "cmp";
  cmp.setup({
    mapping: cmp.mapping.preset.insert({
      //["<C-d>"]: cmp.mapping.scroll_docs(-4),
      //["<C-u>"]: cmp.mapping.scroll_docs(4),
      ["<C-Space:"]: cmp.mapping.complete(),
      ["<C-e>"]: cmp.mapping.abort(),
      ["<CR>"]: cmp.mapping.confirm({ select: true }),
    }),
    sources: cmp.config.sources([
      { name: "nvim_lsp" },
      { name: "buffer" },
      { name: "path" },
    ]),
  });

  import * as lsp_signature from "lsp_signature";
  lsp_signature.setup({});

  cmp.setup.cmdline('/', {
    mapping: cmp.mapping.preset.cmdline(),
    sources: [
      { name: "buffer" }
    ]
  });
  cmp.setup.cmdline(
    ":",
    {
      mapping: cmp.mapping.preset.cmdline(),
      sources: cmp.config.sources(
        [
          { name: "path" },
          { name: "cmdline", option: { ignore_cmds: ["Man", "!"] } },
        ],
      ),
    },
  );
}


function setupNullLs() {
  import * as null_ls from "null-ls";

  null_ls.setup({
    sources: [
      null_ls.builtins.formatting.golines
    ]
  });

}

function setupLspUtils() {
  import * as code_action from "lsputil.codeAction";
  import * as lsp_locations from "lsputil.locations";
  import * as lsp_symbols from "lsputil.symbols";


  // not work any more
  // https://github.com/RishabhRD/nvim-lsputils/issues/44
  //vim.lsp.handlers['textDocument/codeAction'] = code_action.code_action_handler;

  vim.lsp.handlers['textDocument/references'] = lsp_locations.references_handler;
  vim.lsp.handlers['textDocument/definition'] = lsp_locations.definition_handler;
  vim.lsp.handlers['textDocument/declaration'] = lsp_locations.declaration_handler;
  vim.lsp.handlers['textDocument/typeDefinition'] = lsp_locations.typeDefinition_handler;
  vim.lsp.handlers['textDocument/implementation'] = lsp_locations.implementation_handler;
  vim.lsp.handlers['textDocument/documentSymbol'] = lsp_symbols.document_handler
  vim.lsp.handlers['workspace/symbol'] = lsp_symbols.workspace_handler;
  vim.g.lsp_utils_location_opts = { mode: 'editor' };
} 
