-- Plugin path utilities
-- vim.pack installs to: stdpath('data')/site/pack/plugins/opt/
local M = {}

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

M.pack_base = vim.fn.stdpath('data') .. '/site/pack/plugins/opt'
M.opt_path = M.pack_base

-- Get the installation path for a plugin (for build commands)
---@param plugin Plugin
---@return string
function M.get_plugin_path(plugin)
  return M.pack_base .. '/' .. plugin.name
end

-- Check if a plugin is installed by searching all pack directories
---@param plugin Plugin
---@return boolean
function M.is_installed(plugin)
  -- Check vim.pack's directory first
  if vim.uv.fs_stat(M.pack_base .. '/' .. plugin.name) then
    return true
  end
  -- Also check other pack directories (e.g. core/opt from previous installs)
  local data_dir = vim.fn.stdpath('data') .. '/site/pack'
  for dir in vim.fs.dir(data_dir) do
    local path = data_dir .. '/' .. dir .. '/opt/' .. plugin.name
    if vim.uv.fs_stat(path) then
      return true
    end
  end
  return false
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
    if M.is_installed(plugin) then
      table.insert(existing, plugin)
    end
  end
  return existing
end

return M
