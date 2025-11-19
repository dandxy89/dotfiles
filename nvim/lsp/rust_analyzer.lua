return {
  cmd = { 'rustup', 'run', 'stable', 'rust-analyzer' },
  filetypes = { 'rust' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    local cargo_crate_dir = vim.fs.root(fname, { 'Cargo.toml' })

    if cargo_crate_dir == nil then
      on_dir(vim.fs.root(fname, { 'rust-project.json' }))
      return
    end

    vim.system({
      'cargo',
      'metadata',
      '--no-deps',
      '--format-version',
      '1',
      '--manifest-path',
      cargo_crate_dir .. '/Cargo.toml',
    }, { text = true }, function(output)
      if output.code == 0 and output.stdout then
        local result = vim.json.decode(output.stdout)
        on_dir(result.workspace_root and vim.fs.normalize(result.workspace_root) or cargo_crate_dir)
      else
        on_dir(cargo_crate_dir)
      end
    end)
  end,
  settings = {
    ['rust-analyzer'] = {
      cargo = { features = 'all', buildScripts = { enable = true } },
      diagnostics = { enable = true },
      inlayHints = {
        enable = true,
        bindingModeHints = { enable = false },
        chainingHints = { enable = true },
        closingBraceHints = { enable = true, minLines = 25 },
        closureReturnTypeHints = { enable = 'never' },
        lifetimeElisionHints = {
          enable = 'never',
          useParameterNames = false,
        },
        maxLength = 25,
        parameterHints = { enable = true },
        reborrowHints = { enable = 'never' },
        renderColons = true,
        typeHints = {
          enable = true,
          hideClosureInitialization = false,
          hideNamedConstructor = false,
        },
      },
      lens = {
        enable = true,
        methodReferences = true,
        references = true,
        implementations = false,
      },
      interpret = { tests = true },
      procMacro = {
        enable = true,
        ignored = { leptos_macro = { 'component', 'server' } },
      },
    },
  },
}
