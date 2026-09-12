local M = {}
M.last = nil ---@type string?

---@type table<string, table<'suite'|'file'|'nearest', string>>
local runners = {
  rust = { suite = 'cargo test', file = 'cargo test', nearest = 'cargo test %s' },
  python = { suite = 'uv run pytest', file = 'uv run pytest %f', nearest = 'uv run pytest %f::%s' },
}

---Node id of the enclosing test: `Class::method` (python) or `mod::name` (rust).
---@return string?
function M.nearest_name()
  local parts = {} ---@type string[]
  local node = vim.treesitter.get_node()
  while node do
    local t = node:type()
    if t:match('function') or t == 'class_definition' or t == 'mod_item' then
      local name = node:field('name')[1]
      if name then
        table.insert(parts, 1, vim.treesitter.get_node_text(name, 0))
      end
    end
    node = node:parent()
  end
  return #parts > 0 and table.concat(parts, '::') or nil
end

local win ---@type integer?

---@param cmd string
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
