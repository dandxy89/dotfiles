---@type vim.lsp.Config
return {
  cmd = { 'autotools-language-server' },
  filetypes = { 'make' },
  root_markers = { 'Makefile', '.git' },
}
