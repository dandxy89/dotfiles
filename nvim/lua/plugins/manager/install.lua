-- Plugin installation logic using vim.pack.add()
-- Wraps vim.pack to handle custom build commands
-- Plugins install to: ~/.local/share/nvim/site/pack/core/opt/
local M = {}

local path_util = require('util.path')

---@class Plugin
---@field src string Plugin source URL
---@field name string Plugin name
---@field opt boolean Whether plugin is lazy-loaded
---@field trigger? string Trigger for lazy loading
---@field build? string Build command

-- Convert custom plugin specs to vim.pack format
---@param plugins Plugin[]
---@return {src: string, name: string}[]
local function to_pack_specs(plugins)
    local specs = {}
    for _, plugin in ipairs(plugins) do
        table.insert(specs, {src = plugin.src, name = plugin.name})
    end
    return specs
end

-- Handle build commands for plugins that need them
---@param plugins_with_builds Plugin[]
local function handle_builds(plugins_with_builds)
    if #plugins_with_builds == 0 then return end

    print('Building ' .. #plugins_with_builds .. ' plugins...')

    for _, plugin in ipairs(plugins_with_builds) do
        local plugin_path = path_util.get_plugin_path(plugin)
        print('Building ' .. plugin.name .. '...')

        -- Run build command synchronously
        local result = vim.fn.system({
            'sh', '-c',
            'cd ' .. vim.fn.shellescape(plugin_path) .. ' && ' .. plugin.build
        })

        if vim.v.shell_error ~= 0 then
            vim.notify('Build failed for ' .. plugin.name .. ':\n' .. result,
                       vim.log.levels.ERROR)
        else
            print('Built ' .. plugin.name .. ' successfully')
        end
    end
end

-- Check for missing plugins on startup
---@param plugins Plugin[]
function M.ensure_plugins_startup(plugins)
    -- if there are missing plugins to notify the user
    local missing = path_util.get_missing(plugins)

    if #missing > 0 then
        vim.notify('Found ' .. #missing ..
                       ' missing plugins. They will be installed automatically by vim.pack.',
                   vim.log.levels.INFO, {title = 'Plugin Manager'})
    end
end

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

        -- Use vim.pack.add() to install missing plugins
        local specs = to_pack_specs(missing)
        vim.pack.add(specs)

        -- Handle build commands for plugins that need them
        local plugins_with_builds = vim.tbl_filter(function(p)
            return p.build ~= nil
        end, missing)

        handle_builds(plugins_with_builds)

        print('✅ Installed ' .. #missing ..
                  ' plugins! Restart Neovim to apply changes.')
    end, {desc = 'Install missing plugins using vim.pack'})
end

return M
