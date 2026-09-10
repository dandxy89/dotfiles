local M = {}

---@type table<string, string>
local icons = {
  default = '',
  lua = '',
  rs = '',
  py = '',
  ts = '',
  tsx = '',
  js = '',
  jsx = '',
  json = '',
  toml = '',
  yaml = '',
  yml = '',
  md = '',
  sh = '',
  bash = '',
  zsh = '',
  go = '',
  proto = '',
  sql = '',
  html = '',
  css = '',
  vim = '',
  Dockerfile = '',
}
---@type table<string, string>
local mode_hl = {
  n = 'Function',
  i = 'String',
  v = 'ErrorMsg',
  V = 'ErrorMsg',
  ['\22'] = 'ErrorMsg',
  c = 'Statement',
  R = 'Type',
  t = 'ErrorMsg',
  s = 'Number',
  S = 'Number',
  ['\19'] = 'Number',
}
local sev = vim.diagnostic.severity
local diag = { { sev.ERROR, ' ', 'DiagnosticError' }, { sev.WARN, ' ', 'DiagnosticWarn' }, { sev.HINT, ' ', 'DiagnosticHint' } }

---@param group string
---@param text string
---@return string
local function hl(group, text)
  return '%#' .. group .. '#' .. text
end

---@return string
function M.render()
  local win = vim.g.statusline_winid or vim.api.nvim_get_current_win()
  local buf = vim.api.nvim_win_get_buf(win)
  local name = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(buf), ':.')
  if name == '' then
    name = '[No Name]'
  end
  if win ~= vim.api.nvim_get_current_win() then
    return hl('StatusLineNC', ' ' .. name .. ' ')
  end

  local ext = name:match('[^.]+$')
  local parts = {
    hl(mode_hl[vim.fn.mode()] or 'Function', ' ▍'),
    hl('Normal', (icons[ext] or icons.default) .. ' '),
    hl(vim.bo[buf].modified and 'WarningMsg' or vim.bo[buf].readonly and 'ErrorMsg' or 'Title', name .. ' '),
  }
  local git = vim.b[buf].gitsigns_status_dict
  if git then
    for _, d in ipairs({ { 'added', ' ', 'Added' }, { 'changed', '󰝤 ', 'Changed' }, { 'removed', ' ', 'Removed' } }) do
      if (git[d[1]] or 0) > 0 then
        parts[#parts + 1] = hl(d[3], d[2] .. git[d[1]] .. ' ')
      end
    end
  end
  parts[#parts + 1] = '%='
  local progress = vim.lsp.status():match('^[^\n]*')
  if progress ~= '' then
    parts[#parts + 1] = hl('Comment', progress:sub(1, 60) .. ' ')
  end
  local counts = vim.diagnostic.count(buf)
  for _, d in ipairs(diag) do
    if (counts[d[1]] or 0) > 0 then
      parts[#parts + 1] = hl(d[3], d[2] .. counts[d[1]] .. ' ')
    end
  end
  if git and git.head then
    parts[#parts + 1] = hl('Type', ' ' .. git.head .. ' ')
  end
  return table.concat(parts)
end

vim.o.statusline = "%{%v:lua.require'statusline'.render()%}"

return M
