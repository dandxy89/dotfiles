return {
  cmd = { 'ruff', 'server' },
  filetypes = { 'python' },
  root_markers = { 'pyproject.toml', 'ruff.toml', '.ruff.toml' },
  init_options = {
    settings = {
      lint = { enable = true },
      format = { enable = true },
    },
  },
}
