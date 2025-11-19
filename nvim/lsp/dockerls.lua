-- Install: npm install -g dockerfile-language-server-nodejs
return {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile', 'yaml.docker-compose' },
  root_markers = { '.git', vim.uv.cwd() },
  settings = {},
}
