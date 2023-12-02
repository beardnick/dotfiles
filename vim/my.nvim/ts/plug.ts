export function loaded(p: string): boolean {
  return vim.api.nvim_list_runtime_paths().indexOf(`${vim.g.pluginDir}/${p}`) !== -1;
}
