# Sidekick editor bridge

Sidekick's Codex and Codex-resume tools register a session-local MCP server named
`sidekick_editor`. It exposes `open_file(path, line, column)`, backed by the same
`nvim --server … --remote-expr` RPC used to control the hosting Neovim instance.
No global Codex configuration, process discovery, fixed ports, or window IDs are
needed. Python 3 must be available on the machine running Neovim and Codex.

Open Codex with `<leader>kc`, or resume with `<leader>kr`. Ask, for example:

> Find `hist_approx_count_above` and open its implementation in Neovim.

Codex can call `sidekick_editor.open_file` directly. Use `/mcp` in Codex to check
that `sidekick_editor` is connected. Existing Codex terminals must be closed and
reopened once after updating this configuration; hiding/showing a terminal does
not restart its process.

The bridge tracks the last ordinary editor window, ignoring terminals, floats,
and special buffers. If that window closes, another editor window is used; if
none remain, a new split is created. Opening uses `:edit` without `!`, preserving
unsaved work and the Sidekick terminal. Line and column positions are 1-based;
columns count bytes and positions beyond the file are clamped.

The helper can also be called directly from a process with the Sidekick connection
environment (`SIDEKICK_NVIM_SERVER` and `SIDEKICK_NVIM`):

```sh
/path/to/my.nvim/bin/nvim-open '/path/with spaces/file.cc' 608
```

Local and remote Neovim use the same mechanism: the helper and Codex run on the
same machine as the owning editor. Multiplexer session reattachment from a
*different* Neovim instance is not supported: start a new Codex process to bind it
to the new editor. The default Sidekick configuration here does not enable a mux.
