-- Install: cargo install taplo-cli --locked
-- Or via mason: :MasonInstall taplo
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
