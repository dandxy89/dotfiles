---@param compiler 'ruff'|'ty'|'pytest'
---@return fun()
local function make(compiler)
  return function()
    vim.cmd.compiler(compiler)
    vim.bo.makeprg = 'uv run ' .. vim.bo.makeprg
    vim.cmd('silent make! | cwindow')
  end
end

vim.keymap.set('n', '<Leader>mr', make('ruff'), { buffer = 0, desc = 'Ruff check project' })
vim.keymap.set('n', '<Leader>mt', make('ty'), { buffer = 0, desc = 'Ty check project' })
vim.keymap.set('n', '<Leader>mp', make('pytest'), { buffer = 0, desc = 'Pytest to quickfix' })
