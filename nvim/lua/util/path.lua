-- Plugin path utilities
-- vim.pack installs to: stdpath('data')/site/pack/plugins/opt/
local M = {}

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field branch? string Git branch to track
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

M.pack_base = vim.fn.stdpath('data') .. '/site/pack/core/opt'
M.opt_path = M.pack_base

-- Get the installation path for a plugin (for build commands)
-- Searches all pack directories, not just vim.pack's default
---@param plugin Plugin
---@return string
function M.get_plugin_path(plugin)
  -- Check vim.pack's directory first
  local default = M.pack_base .. '/' .. plugin.name
  if vim.uv.fs_stat(default) then
    return default
  end
  -- Search other pack directories (e.g. core/opt)
  local data_dir = vim.fn.stdpath('data') .. '/site/pack'
  for dir in vim.fs.dir(data_dir) do
    local path = data_dir .. '/' .. dir .. '/opt/' .. plugin.name
    if vim.uv.fs_stat(path) then
      return path
    end
  end
  -- Fall back to default if not found anywhere
  return default
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

-- Convert custom plugin specs to vim.pack format
---@param plugins Plugin[]
---@return {src: string, name: string}[]
function M.to_pack_specs(plugins)
  local specs = {}
  for _, plugin in ipairs(plugins) do
    table.insert(specs, { src = plugin.src, name = plugin.name, branch = plugin.branch })
  end
  return specs
end

-- Handle build commands for plugins that need them
---@param plugins_with_builds Plugin[]
function M.handle_builds(plugins_with_builds)
  if #plugins_with_builds == 0 then
    return
  end

  print('Building ' .. #plugins_with_builds .. ' plugins...')

  for _, plugin in ipairs(plugins_with_builds) do
    local plugin_path = M.get_plugin_path(plugin)
    print('Building ' .. plugin.name .. '...')

    local obj = vim.system({ 'sh', '-c', plugin.build }, { cwd = plugin_path }):wait()

    if obj.code ~= 0 then
      vim.notify('Build failed for ' .. plugin.name .. ':\n' .. (obj.stderr or obj.stdout or ''), vim.log.levels.ERROR)
    else
      print('Built ' .. plugin.name .. ' successfully')
    end
  end
end

return M
