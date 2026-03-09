-- Plugin installation logic using vim.pack.add()
-- Wraps vim.pack to handle custom build commands
-- Plugins install to: stdpath('data')/site/pack/core/opt/
local M = {}

local path_util = require('util.path')

-- PackInstall command - installs missing plugins
---@param plugins Plugin[]
function M.setup_command(plugins)
  vim.api.nvim_create_user_command('PackInstall', function()
    local missing = path_util.get_missing(plugins)

    if #missing == 0 then
      print('All ' .. #plugins .. ' plugins already installed!')
      return
    end

    print('Installing ' .. #missing .. ' missing plugins...')

    -- All plugins are already registered with vim.pack at startup.
    -- Just trigger install for missing ones.
    -- confirm = false: avoids Neovim E5248 bug with vim.fn.confirm in :command callbacks
    vim.pack.add(path_util.to_pack_specs(missing), { confirm = false })

    print('Installing ' .. #missing .. ' plugins. Builds will run automatically via PackChanged.')
  end, { desc = 'Install missing plugins using vim.pack' })
end

return M
