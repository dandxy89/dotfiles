-- Test runner (replaces vim-test + vimux)
-- ponytail: rust + python only; add a table entry for another language.
local M = {}

local runners = {
  rust = { suite = 'cargo test', file = 'cargo test', nearest = 'cargo test %s' },
  python = { suite = 'pytest', file = 'pytest %f', nearest = 'pytest %f -k %s' },
}

--- Name of the function the cursor sits in, via treesitter.
---@return string?
function M.nearest_name()
  local node = vim.treesitter.get_node()
  while node do
    if node:type():match('function') then
      local name = node:field('name')[1]
      if name then
        return vim.treesitter.get_node_text(name, 0)
      end
    end
    node = node:parent()
  end
end

local win

local function run(cmd)
  M.last = cmd
  if win and vim.api.nvim_win_is_valid(win) then
    vim.api.nvim_win_close(win, true)
  end
  local from = vim.api.nvim_get_current_win()
  vim.cmd('botright 15split | terminal ' .. cmd)
  win = vim.api.nvim_get_current_win()
  vim.api.nvim_set_current_win(from)
end

---@param kind 'suite'|'file'|'nearest'|'last'
function M.run(kind)
  if kind == 'last' then
    if not M.last then
      vim.notify('No previous test run', vim.log.levels.WARN)
      return
    end
    run(M.last)
    return
  end

  local runner = runners[vim.bo.filetype]
  if not runner then
    vim.notify('No test runner for filetype: ' .. vim.bo.filetype, vim.log.levels.WARN)
    return
  end

  local cmd = runner[kind]
  if cmd:find('%%s') then
    local name = M.nearest_name()
    if not name then
      vim.notify('No test function under the cursor', vim.log.levels.WARN)
      return
    end
    cmd = cmd:gsub('%%s', name)
  end
  run((cmd:gsub('%%f', vim.fn.expand('%:.'))))
end

return M
