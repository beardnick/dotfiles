export function loaded(p: string): boolean {
  if (!vim.g.plugs) {
    vim.notify('vim-plug not installed no g:plugs');
    return false;
  }
  const dir = vim.g.plugs[p]?.dir;
  if (!dir) {
    return false;
  }
  return vim.fn.isdirectory(dir) === 1;
}
