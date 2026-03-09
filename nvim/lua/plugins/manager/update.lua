-- Plugin update logic using native vim.pack.update()
-- Updates are logged to: ~/.local/state/nvim/nvim-pack.log
local M = {}

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

  -- All plugins are already registered with vim.pack at startup.
  -- Builds run automatically via the PackChanged autocommand.
  vim.pack.update(plugin_names, {
    force = opts.force or false,
  })
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

  -- Command to rebuild plugins that have build commands
  vim.api.nvim_create_user_command('PackBuild', function()
    local path_util = require('util.path')
    local plugins_with_builds = vim.tbl_filter(function(p)
      return p.build ~= nil
    end, plugins)

    path_util.handle_builds(plugins_with_builds)
  end, {
    desc = 'Run build commands for plugins that need them',
  })
end

return M
