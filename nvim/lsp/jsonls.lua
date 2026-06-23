return {
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  cmd = { 'vscode-json-language-server', '--stdio' },
  settings = {
    json = {
      validate = { enable = true },
      -- jsonls fetches schemas from the SchemaStore catalog itself.
      schemas = {},
    },
  },
}
