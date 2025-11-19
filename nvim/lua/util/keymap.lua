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

-- Batch set keymaps from table
-- Usage: set_batch("n", { {"key", "cmd", {opts}}, ... })
---@param mode string|string[]
---@param mappings table[] Array of {lhs, rhs, opts?} tuples
---@param default_opts? table
function M.set_batch(mode, mappings, default_opts)
  default_opts = vim.tbl_extend('force', M.opts, default_opts or {})
  for _, map in ipairs(mappings) do
    local lhs, rhs, opts = map[1], map[2], map[3] or {}
    vim.keymap.set(mode, lhs, rhs, vim.tbl_extend('force', default_opts, opts))
  end
end

-- Simple map with description
---@param mode string|string[]
---@param lhs string
---@param rhs string|function
---@param desc string
---@param opts? table
function M.map(mode, lhs, rhs, desc, opts)
  opts = opts or {}
  opts.desc = desc
  opts = vim.tbl_extend('force', M.opts, opts)
  vim.keymap.set(mode, lhs, rhs, opts)
end

return M
