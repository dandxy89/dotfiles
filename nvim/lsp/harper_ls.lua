return {
  cmd = { 'harper-ls', '--stdio' },
  filetypes = { 'markdown', 'text', 'lua', 'rust' },
  settings = {
    ['harper-ls'] = {
      userDictPath = '~/dict.txt',
      codeActions = { ForceStable = false },
      markdown = { IgnoreLinkTitle = false },
      diagnosticSeverity = 'hint',
      isolateEnglish = false,
      dialect = 'British',
    },
  },
}
