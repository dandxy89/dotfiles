local python_paths = {} ---@type table<string, string|false> cached `uv python find` per root_dir

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
    local root = config.root_dir or vim.fn.getcwd()
    if python_paths[root] == nil then
      local res = vim.system({ 'uv', 'python', 'find' }, { cwd = root }):wait()
      python_paths[root] = res.code == 0 and vim.trim(res.stdout or '') or false
    end
    if python_paths[root] then
      config.settings = vim.tbl_deep_extend('force', config.settings or {}, {
        python = { pythonPath = python_paths[root] },
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
