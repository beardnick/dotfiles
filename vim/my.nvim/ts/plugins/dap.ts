import * as plug from "../plug";

let map = vim.keymap.set;
let mapopt = { noremap: true, silent: true };

if (plug.loaded("nvim-dap")) {
  setupDap();
}

if (plug.loaded("nvim-dap-virtual-text")) {
  setupDapVirtualText();
}

if (plug.loaded("nvim-dap-ui")) {
  setupDapUI();
}

if (plug.loaded("persistent-breakpoints.nvim")) {
  setupPersistBreakPoint();
}

function setupDap() {
  import * as dap from "dap";
  import * as dap_vscode from "dap.ext.vscode";

  map("n", "<leader>dd", dap.toggle_breakpoint, mapopt)
  map("n", "<leader>di", dap.step_into, mapopt)
  map("n", "<leader>do", dap.step_out, mapopt)
  map("n", "<leader>dn", dap.step_over, mapopt)
  map("n", "<leader>dc", () => {
    if (vim.fn.filereadable(".vim/launch.json")) {
      dap_vscode.load_launchjs(".vim/launch.json")
    }
    else if (vim.fn.filereadable(".vscode/launch.json")) {
      dap_vscode.load_launchjs(".vscode/launch.json")
    }
    dap.continue();
  }, mapopt)
  map("n", "<leader>ds", dap.disconnect, mapopt)

  vim.fn.sign_define(
    "DapBreakpoint",
    {
      text: "",
      texthl: "LspDiagnosticsSignError",
      linehl: "",
      numhl: "",
    },
  );
  vim.fn.sign_define(
    "DapBreakpointRejected",
    {
      text: "",
      texthl: "LspDiagnosticsSignHint",
      linehl: "",
      numhl: "",
    },
  );
  vim.fn.sign_define(
    "DapStopped",
    {
      text: "",
      texthl: "LspDiagnosticsSignInformation",
      linehl: "DiagnosticUnderlineInfo",
      numhl: "LspDiagnosticsSignInformation",
    },
  );

  dap.adapters.go = {
    type: 'server',
    port: '${port}',
    executable: {
      command: 'dlv',
      args: ['dap', '-l', '127.0.0.1:${port}'],
    }
  }
  dap.configurations.go = [
    {
      type: "go",
      name: "Debug",
      request: "launch",
      program: "${file}"
    },
    {
      name: "Launch Package",
      type: "go",
      request: "launch",
      program: "${fileDirname}",
    },
    {
      type: "go",
      name: "Debug test", // configuration for debugging test files
      request: "launch",
      mode: "test",
      program: "${file}"
    },
    // works with go.mod packages and sub packages
    {
      type: "go",
      name: "Debug test (go.mod)",
      request: "launch",
      mode: "test",
      program: "./${relativeFileDirname}"
    }
  ];

}



function setupDapVirtualText() {
  import * as dap_virtual_text from "nvim-dap-virtual-text";
  dap_virtual_text.setup({
    enabled: true,                     // enable this plugin (the default)
    enabled_commands: true,            // create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
    highlight_changed_variables: true, // highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
    highlight_new_as_changed: true,    // highlight new variables in the same way as changed variables (if highlight_changed_variables)
    show_stop_reason: true,            // show stop reason when stopped for exceptions
    commented: true,                   // prefix virtual text with comment string
    virt_text_pos: 'eol',              // position of virtual text, see `:h nvim_buf_set_extmark()`
  });
}

function setupPersistBreakPoint() {
  import * as persistent_breakpoints from "persistent-breakpoints";
  import * as persistent_breakpoints_api from "persistent-breakpoints.api";
  persistent_breakpoints.setup({
    load_breakpoints_event: ["BufReadPost"]
  });
  map("n", "<leader>dd", persistent_breakpoints_api.toggle_breakpoint, mapopt);
}

function setupDapUI() {
  import * as dap from "dap";
  import * as dapui from "dapui";
  dapui.setup({
    icons: { expanded: "▾", collapsed: "▸" },
    mappings: {
      // Use a table to apply multiple mappings
      expand: ["<CR>", "<2-LeftMouse>"],
      open: "o",
      remove: "d",
      edit: "e",
      repl: "r",
      toggle: "t",
    },
    sidebar: {
      // You can change the order of elements in the sidebar
      elements: [
        // Provide as ID strings or tables with "id" and "size" keys
        {
          id: "scopes",
          size: 0.25, // Can be float or integer > 1
        },
        { id: "breakpoints", size: 0.25 },
        { id: "stacks", size: 0.25 },
        { id: "watches", size: 0.25 },
      ],
      size: 40,
      position: "left", // Can be "left", "right", "top", "bottom"
    },
    tray: {
      elements: ["repl"],
      size: 10,
      position: "bottom", // Can be "left", "right", "top", "bottom"
    },
    floating: {
      max_height: null,  // These can be integers or a float between 0 and 1.
      max_width: null,   // Floats will be treated as percentage of your screen.
      border: "single", // Border style. Can be "single", "double" or "rounded"
      mappings: {
        close: ["q", "<Esc>"],
      },
    },
    windows: { indent: 1 },
  });
  dap.listeners.after.event_initialized["dapui_config"] = () => dapui.open();
  dap.listeners.before.event_terminated["dapui_config"] = () => dapui.close();
  dap.listeners.before.event_exited["dapui_config"] = () => dapui.close();
  // watch datas in float window
  map('n', '<leader>dk', () => dapui.float_element("scopes", { width: 100, height: 20, enter: true }), mapopt);

}
