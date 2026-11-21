-- PowerShellEditorServices: a zip bundle run by pwsh (bootstrap-macos.sh unpacks it here).
local bundle = vim.fs.joinpath(vim.env.HOME, '.local/share/powershell_es')
local start = vim.fs.joinpath(bundle, 'PowerShellEditorServices/Start-EditorServices.ps1')

---@type vim.lsp.Config
return {
  -- A missing bundle maps to a non-executable cmd so core/lsp.lua skips the server.
  cmd = vim.uv.fs_stat(start) and {
    'pwsh',
    '-NoLogo',
    '-NoProfile',
    '-Command',
    table
      .concat({
        "& '%s' -BundledModulesPath '%s' -LogPath '%s' -SessionDetailsPath '%s'",
        '-FeatureFlags @() -AdditionalModules @() -HostName nvim -HostProfileId 0',
        '-HostVersion 1.0.0 -Stdio -LogLevel Normal',
      }, ' ')
      :format(
        start,
        bundle,
        vim.fs.joinpath(vim.fn.stdpath('log'), 'powershell_es.log'),
        vim.fs.joinpath(vim.fn.stdpath('cache'), 'powershell_es.session.json')
      ),
  } or { 'powershell-editor-services-not-installed' },
  filetypes = { 'ps1' },
  root_markers = { 'PSScriptAnalyzerSettings.psd1', '.git' },
}
