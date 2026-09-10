vim.opt_local.errorformat = '%f:%l:%c: %m,%-G%.%#'

---@param tool 'ruff'|'ty'
---@return fun()
local function check(tool)
  return function()
    vim.opt_local.makeprg = 'uv run ' .. tool .. ' check --output-format concise .'
    vim.cmd('silent make! | copen')
  end
end

vim.keymap.set('n', '<Leader>mr', check('ruff'), { buffer = 0, desc = 'Ruff check project' })
vim.keymap.set('n', '<Leader>mt', check('ty'), { buffer = 0, desc = 'Ty check project' })
