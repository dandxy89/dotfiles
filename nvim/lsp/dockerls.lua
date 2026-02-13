-- Install: npm install -g dockerfile-language-server-nodejs
return {
  cmd = { 'docker-langserver', '--stdio' },
  filetypes = { 'dockerfile' },
  root_markers = { '.git' },
  settings = {},
}
