---@type vim.lsp.Config
return {
  cmd = {
    'sh',
    '-c',
    'if rust-analyzer --version >/dev/null 2>&1; then exec rust-analyzer "$@"; ' .. 'else exec rustup run nightly rust-analyzer "$@"; fi',
    'rust-analyzer',
  },
  filetypes = { 'rust', 'toml' },
  root_dir = function(bufnr, on_dir)
    local fname = vim.api.nvim_buf_get_name(bufnr)
    if vim.bo[bufnr].filetype == 'toml' and vim.fs.basename(fname) ~= 'Cargo.toml' then
      return
    end
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
        local ok, result = pcall(vim.json.decode, output.stdout)
        on_dir(ok and result.workspace_root and vim.fs.normalize(result.workspace_root) or cargo_crate_dir)
      else
        on_dir(cargo_crate_dir)
      end
    end)
  end,
  -- Only non-default values; see rust-analyzer.github.io/book/configuration.html
  settings = {
    ['rust-analyzer'] = {
      lens = {
        methodReferences = { enable = true },
        references = { enable = true },
        implementations = { enable = false },
      },
      interpret = { tests = true },
      procMacro = { ignored = { leptos_macro = { 'component', 'server' } } },
    },
  },
}
