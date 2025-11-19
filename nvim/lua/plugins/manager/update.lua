-- Plugin update logic using native vim.pack.update()
-- Updates are logged to: ~/.local/state/nvim/nvim-pack.log
local M = {}

local path_util = require('util.path')

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

-- Handle build commands for plugins that need them
---@param plugins_with_builds Plugin[]
local function handle_builds(plugins_with_builds)
  if #plugins_with_builds == 0 then
    return
  end

  print('\n🔨 Building ' .. #plugins_with_builds .. ' updated plugins...')

  for _, plugin in ipairs(plugins_with_builds) do
    local plugin_path = path_util.get_plugin_path(plugin)
    print('Building ' .. plugin.name .. '...')

    local result = vim.fn.system({
      'sh',
      '-c',
      'cd ' .. vim.fn.shellescape(plugin_path) .. ' && ' .. plugin.build,
    })

    if vim.v.shell_error ~= 0 then
      vim.notify('Build failed for ' .. plugin.name .. ':\n' .. result, vim.log.levels.ERROR)
    else
      print('Built ' .. plugin.name .. ' successfully')
    end
  end
end

-- Update plugins using native vim.pack API
---@param plugins Plugin[]
---@param opts? {force?: boolean}
function M.update_plugins(plugins, opts)
  opts = opts or {}

  -- Extract plugin names (vim.pack.update expects an array of names)
  local plugin_names = {}
  for _, plugin in ipairs(plugins) do
    table.insert(plugin_names, plugin.name)
  end

  if #plugin_names == 0 then
    print('No plugins configured to update!')
    return
  end

  -- This provides:
  --   - Built-in confirmation UI (unless force = true)
  --   - Automatic changelog and revision tracking
  --   - LSP support (gO, K, gra) in confirmation buffer
  --   - Navigation with ]] and [[ between plugin sections
  --   - Logging to "nvim-pack.log" in log stdpath
  vim.pack.update(plugin_names, {
    force = opts.force or false,
  })

  -- Note: Build commands need to be run manually after updates complete
  -- vim.pack.update() is async, so builds would need to be in a callback
  -- For now, users should run builds manually with :PackBuild if needed
end

-- PackUpdate command with optional bang for force update
---@param plugins Plugin[]
function M.setup_command(plugins)
  vim.api.nvim_create_user_command('PackUpdate', function(cmd_opts)
    M.update_plugins(plugins, {
      force = cmd_opts.bang,
    })
  end, {
    bang = true,
    desc = 'Update plugins (add ! to skip confirmation)',
  })

  -- Optional: Command to rebuild plugins that have build commands
  vim.api.nvim_create_user_command('PackBuild', function()
    local plugins_with_builds = vim.tbl_filter(function(p)
      return p.build ~= nil
    end, plugins)

    handle_builds(plugins_with_builds)
  end, {
    desc = 'Run build commands for plugins that need them',
  })
end

return M
