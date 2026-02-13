-- Plugin path utilities
-- Note: These paths are for legacy compatibility with custom lazy loading
-- vim.pack installs to: stdpath('data')/site/pack/core/opt/
local M = {}

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

M.pack_base = vim.fn.stdpath('data') .. '/site/pack/core/opt'
M.start_path = M.pack_base -- Legacy: vim.pack uses 'opt' for all plugins
M.opt_path = M.pack_base

-- Get the installation path for a plugin
-- vim.pack installs all plugins to the same location
---@param plugin Plugin
---@return string
function M.get_plugin_path(plugin)
  return M.pack_base .. '/' .. plugin.name
end

-- Check if a plugin is installed
---@param plugin Plugin
---@return boolean
function M.is_installed(plugin)
  return vim.uv.fs_stat(M.get_plugin_path(plugin)) ~= nil
end

-- Get list of missing plugins
---@param plugins Plugin[]
---@return Plugin[]
function M.get_missing(plugins)
  local missing = {}
  for _, plugin in ipairs(plugins) do
    if not M.is_installed(plugin) then
      table.insert(missing, plugin)
    end
  end
  return missing
end

-- Get list of existing plugins
---@param plugins Plugin[]
---@return Plugin[]
function M.get_existing(plugins)
  local existing = {}
  for _, plugin in ipairs(plugins) do
    local plugin_path = M.get_plugin_path(plugin)
    if vim.uv.fs_stat(plugin_path) then
      table.insert(existing, plugin)
    end
  end
  return existing
end

return M
