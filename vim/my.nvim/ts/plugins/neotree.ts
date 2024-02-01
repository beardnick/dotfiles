import * as plug from "../plug";

let map = vim.keymap.set;
let mapopt = { noremap: true, silent: true };

if (plug.loaded("neo-tree.nvim")) {
  setupNeoTree();
}

function setupNeoTree() {
  import * as neo_tree from "neo-tree";

  neo_tree.setup({
    window: {
      mapping_options: {
        noremap: true,
        nowait: true,
      },
      mappings: {
        ["l"]: { 1: "toggle_node", nowait: false },
        ["h"]: { 1: "toggle_node", nowait: false },
      }
    }
  });

  map("n", "<leader>ft", "<cmd>Neotree toggle<cr>", mapopt);

}
