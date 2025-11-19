local config_path = vim.fn.stdpath('config')

return {
  filetypes = { 'json', 'jsonc' },
  root_markers = { '.git' },
  cmd = { 'vscode-json-language-server', '--stdio' },
  settings = {
    json = {
      validate = { enable = true },
      schemas = {
        {
          fileMatch = { 'package.json' },
          url = 'file://' .. config_path .. '/schemas/package.json',
        },
        {
          fileMatch = { 'tsconfig*.json' },
          url = 'file://' .. config_path .. '/schemas/tsconfig.json',
        },
      },
    },
  },
}
