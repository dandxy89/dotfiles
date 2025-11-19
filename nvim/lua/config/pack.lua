local pack = require('plugins.pack')
local path_util = require('util.path')

-- Check for missing core (non-opt) plugins that block startup
local missing_core = {}
local missing_opt = {}

for _, plugin in ipairs(pack.plugins) do
  if not path_util.is_installed(plugin) then
    if plugin.opt then
      table.insert(missing_opt, plugin)
    else
      table.insert(missing_core, plugin)
    end
  end
end

-- Core plugins must be installed synchronously (they're needed immediately)
if #missing_core > 0 then
  vim.notify('Installing ' .. #missing_core .. ' core plugins...', vim.log.levels.INFO)
  for _, plugin in ipairs(missing_core) do
    local plugin_path = path_util.get_plugin_path(plugin)
    vim.notify('  Installing ' .. plugin.name .. '...', vim.log.levels.INFO)
    local result = vim.fn.system({ 'git', 'clone', '--depth=1', plugin.url, plugin_path })
    if vim.v.shell_error ~= 0 then
      vim.notify('Failed to install ' .. plugin.name .. ': ' .. result, vim.log.levels.ERROR)
    elseif plugin.build then
      vim.notify('  Building ' .. plugin.name .. '...', vim.log.levels.INFO)
      vim.fn.system({ 'sh', '-c', 'cd ' .. vim.fn.shellescape(plugin_path) .. ' && ' .. plugin.build })
    end
  end
  vim.notify('Core plugins installed. Restart Neovim for best experience.', vim.log.levels.WARN)
end

-- Optional plugins can be installed async later via :PackInstall
if #missing_opt > 0 then
  vim.defer_fn(function()
    vim.notify(#missing_opt .. " optional plugins missing. Run ':PackInstall' to install.", vim.log.levels.INFO)
  end, 100)
end

pack.setup_lazy_loading()
