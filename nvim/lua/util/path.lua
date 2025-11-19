-- Plugin path utilities
local M = {}

M.pack_base = vim.fn.stdpath('data') .. '/site/pack/plugins'
M.start_path = M.pack_base .. '/start'
M.opt_path = M.pack_base .. '/opt'

-- Get the correct installation path for a plugin
function M.get_plugin_path(plugin)
    local base = plugin.opt and M.opt_path or M.start_path
    return base .. '/' .. plugin.name
end

-- Check if a plugin is installed
function M.is_installed(plugin)
    return vim.uv.fs_stat(M.get_plugin_path(plugin)) ~= nil
end

-- Get list of missing plugins
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
function M.get_existing(plugins)
    local existing = {}
    for _, plugin in ipairs(plugins) do
        local plugin_path = M.get_plugin_path(plugin)
        if vim.fn.isdirectory(plugin_path) == 1 then
            table.insert(existing, plugin)
        end
    end
    return existing
end

return M
