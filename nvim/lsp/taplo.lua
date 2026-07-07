-- Install: cargo install taplo-cli --locked
---@type vim.lsp.Config
return {
  cmd = { 'taplo', 'lsp', 'stdio' },
  filetypes = { 'toml' },
  root_markers = { '.git' },
  settings = {
    taplo = {
      formatting = {
        alignEntries = false,
        reorderKeys = true,
      },
    },
  },
}
