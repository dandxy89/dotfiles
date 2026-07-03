-- Keymap utilities for consistent keymap handling
local M = {}

-- Default options for most keymaps
M.opts = { noremap = true, silent = true }

-- Bind helper - creates a keymap setter with default options
---@param mode string|string[]
---@param outer_opts? table
---@return function
function M.bind(mode, outer_opts)
  outer_opts = vim.tbl_extend('force', M.opts, outer_opts or {})
  return function(lhs, rhs, opts)
    opts = vim.tbl_extend('force', outer_opts, opts or {})
    vim.keymap.set(mode, lhs, rhs, opts)
  end
end

return M
