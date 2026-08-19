-- Enable every server with a config file in lsp/.
-- Completion capabilities are registered by blink.cmp's own plugin file
-- (vim.lsp.config('*')), which runs before servers attach since blink is eager.
local server_names = {}
for file in vim.fs.dir(vim.fn.stdpath('config') .. '/lsp') do
  local name = file:match('(.+)%.lua$')
  if name then
    table.insert(server_names, name)
  end
end
vim.lsp.enable(server_names)

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
  virtual_text = { spacing = 4, prefix = '●' },
  underline = true,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
})

-- Inlay hints (replaces nvim-lsp-endhints; servers are configured in lsp/*.lua)
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom_inlay_hints', { clear = true }),
  callback = function(ev)
    vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
  end,
})
