local server_names = {} ---@type string[]
for file in vim.fs.dir(vim.fn.stdpath('config') .. '/lsp') do
  local name = file:match('(.+)%.lua$')
  if name then
    -- skip servers that are not installed instead of erroring on every matching buffer
    local cmd = (vim.lsp.config[name] or {}).cmd
    if type(cmd) ~= 'table' or vim.fn.executable(cmd[1]) == 1 then
      table.insert(server_names, name)
    end
  end
end
vim.lsp.enable(server_names)

-- Big files: no language server, no inlay hints
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('custom_lsp_bigfile', { clear = true }),
  callback = function(ev)
    if vim.b[ev.buf].bigfile then
      vim.lsp.inlay_hint.enable(false, { bufnr = ev.buf })
      vim.schedule(function()
        vim.lsp.buf_detach_client(ev.buf, ev.data.client_id)
      end)
    end
  end,
})

local signs = { ERROR = '', WARN = '', HINT = '', INFO = '' }
local numhl, text = {}, {} ---@type table<vim.diagnostic.Severity, string>, table<vim.diagnostic.Severity, string>
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

vim.lsp.inlay_hint.enable(true)
vim.lsp.codelens.enable(true)
