-- LSP configuration using native Neovim 0.11+ vim.lsp.enable()
-- Server configs are loaded automatically from the lsp/ directory

-- Set global capabilities (merge with blink.cmp if available)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, 'blink.cmp')
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Discover all server names from the lsp/ directory
local server_names = {}
local lsp_dir = vim.fn.stdpath('config') .. '/lsp'
for file in vim.fs.dir(lsp_dir) do
  local name = file:match('(.+)%.lua$')
  if name then
    table.insert(server_names, name)
  end
end

-- Enable all discovered servers (Neovim loads configs from lsp/ automatically)
vim.lsp.enable(server_names)

-- Re-trigger filetype for already-open buffers (handles race with lazy loading)
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local ft = vim.bo[bufnr].filetype
    if ft and ft ~= '' then
      vim.api.nvim_exec_autocmds('FileType', { buffer = bufnr })
    end
  end
end

-- Create LspInfo command since we're not using nvim-lspconfig
vim.api.nvim_create_user_command('LspInfo', function()
  local clients = vim.lsp.get_clients({ bufnr = 0 })
  local lines = { 'LSP clients attached to buffer ' .. vim.api.nvim_get_current_buf() .. ':\n' }

  if #clients == 0 then
    table.insert(lines, '  No LSP clients attached')
  else
    for _, client in ipairs(clients) do
      table.insert(lines, string.format('  - %s (ID: %d)', client.name, client.id))
      table.insert(lines, string.format('    Root: %s', client.root_dir or 'N/A'))
      table.insert(lines, string.format('    Filetypes: %s', table.concat(client.config.filetypes or {}, ', ')))
    end
  end

  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, {})

-- Debug command to check configured LSPs
vim.api.nvim_create_user_command('LspConfigured', function()
  local lines = { 'Configured LSP servers:\n' }
  for _, name in ipairs(server_names) do
    table.insert(lines, string.format('  - %s', name))
  end
  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, {})

require('mason').setup({})

-- Configure diagnostic signs
local signs = { ERROR = '', WARN = '', HINT = '', INFO = '' }
local numhl, text = {}, {}
for name, icon in pairs(signs) do
  local severity = vim.diagnostic.severity[name]
  numhl[severity] = 'DiagnosticSign' .. name:sub(1, 1):upper() .. name:sub(2):lower()
  text[severity] = icon
end

vim.diagnostic.config({
  signs = { numhl = numhl, text = text },
  update_in_insert = false,
  virtual_text = {
    spacing = 4,
    prefix = '●',
  },
  underline = true,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'if_many',
  },
})
