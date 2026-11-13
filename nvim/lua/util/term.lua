local M = {}
local bufs = {} ---@type table<string, integer>

---@param cmd string shell command
---@param layout 'bottom'|'right'|'tab'
---@return nil
function M.toggle(cmd, layout)
  local bin = vim.split(cmd, ' ', { plain = true })[1]
  if vim.fn.executable(bin) ~= 1 then
    return vim.notify(bin .. ' not found on PATH', vim.log.levels.ERROR)
  end
  local buf = bufs[cmd]
  local win = buf and vim.fn.bufwinid(buf) or -1
  if win ~= -1 then
    vim.api.nvim_win_hide(win)
    return
  end
  local open = ({ bottom = 'botright 15split', right = 'vertical botright 60vsplit', tab = 'tabnew' })[layout]
  vim.cmd(open)
  if buf and vim.api.nvim_buf_is_valid(buf) then
    vim.api.nvim_win_set_buf(0, buf)
  else
    vim.cmd.terminal(cmd)
    bufs[cmd] = vim.api.nvim_get_current_buf()
    vim.bo.buflisted = false
    if layout == 'tab' then
      vim.api.nvim_create_autocmd('TermClose', { buffer = 0, once = true, command = 'bdelete!' })
    end
  end
  vim.cmd.startinsert()
end

return M
