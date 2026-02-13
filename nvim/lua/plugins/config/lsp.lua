---@class LspServerConfig
---@field filetypes? string[]
---@field root_markers? string[]
---@field cmd? string[]
---@field settings? table

-- Set global capabilities (merge with blink.cmp if available)
local capabilities = vim.lsp.protocol.make_client_capabilities()
local ok, blink = pcall(require, 'blink.cmp')
if ok then
  capabilities = blink.get_lsp_capabilities(capabilities)
end

vim.lsp.config('*', {
  capabilities = capabilities,
})

-- Load all server configurations from the lsp/ directory
---@type table<string, LspServerConfig>
local server_configs = {}
local lsp_servers_path = vim.fn.stdpath('config') .. '/lsp'
for file in vim.fs.dir(lsp_servers_path) do
  local server_name = file:match('(.+)%.lua$')
  if server_name then
    local config_path = lsp_servers_path .. '/' .. file
    local load_ok, config = pcall(dofile, config_path)
    if load_ok and type(config) == 'table' then
      server_configs[server_name] = config
    else
      vim.notify('Failed to load LSP config: ' .. server_name .. ': ' .. tostring(config), vim.log.levels.WARN)
    end
  end
end

-- Function to start LSP for a buffer
---@param bufnr number
---@param filetype string
local function start_lsp_for_buffer(bufnr, filetype)
  for server_name, config in pairs(server_configs) do
    if config.filetypes and vim.tbl_contains(config.filetypes, filetype) then
      local lsp_config = vim.tbl_extend('force', {
        name = server_name,
        bufnr = bufnr,
      }, config)

      -- Resolve root_dir from root_markers if provided
      if config.root_markers then
        lsp_config.root_dir = vim.fs.root(vim.api.nvim_buf_get_name(bufnr), config.root_markers)
        lsp_config.root_markers = nil
      end

      vim.lsp.start(lsp_config)
    end
  end
end

-- Create an autocommand to start LSP servers on FileType
vim.api.nvim_create_autocmd('FileType', {
  group = vim.api.nvim_create_augroup('user_lsp_starter', { clear = true }),
  callback = function(args)
    start_lsp_for_buffer(args.buf, args.match)
  end,
})

-- Attach LSP to any already-open buffers (handles race condition with lazy loading)
for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
  if vim.api.nvim_buf_is_loaded(bufnr) then
    local filetype = vim.bo[bufnr].filetype
    if filetype and filetype ~= '' then
      start_lsp_for_buffer(bufnr, filetype)
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
      table.insert(lines, string.format('  • %s (ID: %d)', client.name, client.id))
      table.insert(lines, string.format('    Root: %s', client.root_dir or 'N/A'))
      table.insert(lines, string.format('    Filetypes: %s', table.concat(client.config.filetypes or {}, ', ')))
    end
  end

  vim.notify(table.concat(lines, '\n'), vim.log.levels.INFO)
end, {})

-- Debug command to check configured LSPs
vim.api.nvim_create_user_command('LspConfigured', function()
  local lines = { 'Configured LSP servers:\n' }
  for name, _ in pairs(server_configs) do
    table.insert(lines, string.format('  • %s', name))
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
  update_in_insert = false, -- Better performance
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

local icons = {
  Class = ' ',
  Color = ' ',
  Constant = ' ',
  Constructor = ' ',
  Enum = ' ',
  EnumMember = ' ',
  Event = ' ',
  Field = ' ',
  File = ' ',
  Folder = ' ',
  Function = '󰊕 ',
  Interface = ' ',
  Keyword = ' ',
  Method = 'ƒ ',
  Module = '󰏗 ',
  Property = ' ',
  Snippet = ' ',
  Struct = ' ',
  Text = ' ',
  Unit = ' ',
  Value = ' ',
  Variable = ' ',
}

local completion_kinds = vim.lsp.protocol.CompletionItemKind
for i, kind in ipairs(completion_kinds) do
  completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
end
