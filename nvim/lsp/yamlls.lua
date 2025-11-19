return {
  cmd = { 'yaml-language-server', '--stdio' },
  filetypes = { 'yaml', 'yml' },
  root_markers = { '.git' },
  settings = {
    yaml = {
      schemas = {
        ['https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json'] = 'docker-compose.yml',
      },
    },
  },
}
