---@param name string
---@return integer
local function augroup(name)
  return vim.api.nvim_create_augroup('custom_' .. name, { clear = true })
end

---@param bufnr integer
---@param kind string
local function ruff_action(bufnr, kind)
  local client = vim.lsp.get_clients({ bufnr = bufnr, name = 'ruff' })[1]
  if not client then
    return
  end
  local range = vim.lsp.util.make_range_params(0, client.offset_encoding)
  ---@type lsp.CodeActionParams
  local params = { textDocument = range.textDocument, range = range.range, context = { only = { kind }, diagnostics = {} } }
  local res = client:request_sync('textDocument/codeAction', params, 2000, bufnr)
  for _, action in ipairs(res and res.result or {}) do
    if not action.edit and action.data then
      local resolved = client:request_sync('codeAction/resolve', action, 2000, bufnr)
      action = resolved and resolved.result or action
    end
    if action.edit then
      vim.lsp.util.apply_workspace_edit(action.edit, client.offset_encoding)
    end
  end
end

vim.api.nvim_create_autocmd('BufWritePre', {
  pattern = { '*.rs', '*.py', '*.toml' },
  group = augroup('FormatOnSave'),
  callback = function(ev)
    if not vim.g.disable_autoformat then
      if vim.bo[ev.buf].filetype == 'python' then
        ruff_action(ev.buf, 'source.fixAll')
        ruff_action(ev.buf, 'source.organizeImports')
      end
      vim.lsp.buf.format({
        async = false,
        timeout_ms = 3000,
        filter = function(c)
          return c.name ~= 'basedpyright'
        end,
      })
    end
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('StripWhitespace'),
  callback = function()
    if not vim.bo.modifiable then
      return
    end
    local pos = vim.api.nvim_win_get_cursor(0)
    vim.cmd([[ %s/\s\+$//e ]])
    pcall(vim.api.nvim_win_set_cursor, 0, pos)
  end,
})

vim.api.nvim_create_autocmd('BufWritePre', {
  group = augroup('AutoCreateDirs'),
  callback = function()
    local dir = vim.fn.expand('<afile>:p:h')
    if not dir:find('://') and vim.fn.isdirectory(dir) == 0 then
      vim.fn.mkdir(dir, 'p')
    end
  end,
})

vim.api.nvim_create_autocmd('BufReadPre', {
  group = augroup('BigFile'),
  callback = function(ev)
    if vim.fn.getfsize(ev.match) > 1024 * 1024 then
      vim.b[ev.buf].bigfile = true
      vim.bo[ev.buf].undolevels = -1
      vim.opt_local.foldmethod = 'manual'
    end
  end,
})

vim.api.nvim_create_autocmd({ 'TextYankPost', 'TextPutPost' }, {
  group = augroup('highlight_yank'),
  callback = function()
    vim.hl.hl_op({ timeout = 200 })
  end,
})

vim.api.nvim_create_autocmd('FileType', {
  group = augroup('CloseWithEsc'),
  pattern = { 'help', 'qf', 'checkhealth', 'man' },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set('n', '<esc>', function()
      vim.cmd('close')
      pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
    end, { buffer = event.buf, silent = true, desc = 'Quit buffer' })
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  group = augroup('AutoResizeWindows'),
  command = 'tabdo wincmd =',
})

vim.api.nvim_create_autocmd('BufReadPost', {
  group = augroup('JumpToLastPosition'),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    if mark[1] > 1 and mark[1] <= vim.api.nvim_buf_line_count(0) then
      vim.api.nvim_win_set_cursor(0, mark)
    end
  end,
})

local hl = augroup('LspReferences')
vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
  group = hl,
  callback = function(ev)
    if #vim.lsp.get_clients({ bufnr = ev.buf, method = 'textDocument/documentHighlight' }) > 0 then
      vim.lsp.buf.document_highlight()
    end
  end,
})
vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
  group = hl,
  callback = vim.lsp.buf.clear_references,
})

vim.api.nvim_create_autocmd('LspProgress', {
  group = augroup('LspProgress'),
  command = 'redrawstatus',
})
