---@type vim.lsp.Config
return {
  cmd = { 'basedpyright-langserver', '--stdio' },
  filetypes = { 'python' },
  root_markers = {
    'pyrightconfig.json',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    'Pipfile',
    '.git',
  },
  before_init = function(_, config)
    local res = vim.system({ 'uv', 'python', 'find' }, { cwd = config.root_dir }):wait()
    if res.code == 0 then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        python = { pythonPath = vim.trim(res.stdout) },
      })
    end
  end,
  settings = {
    basedpyright = {
      analysis = {
        autoSearchPaths = true,
        autoImportCompletions = true,
        useLibraryCodeForTypes = true,
        diagnosticMode = 'openFilesOnly',
        -- ponytail: ty owns type diagnostics; basedpyright is hover/completion/rename/inlay only
        typeCheckingMode = 'off',
        inlayHints = {
          variableTypes = true,
          callArgumentNames = true,
          functionReturnTypes = true,
          genericTypes = false,
        },
      },
    },
  },
}
