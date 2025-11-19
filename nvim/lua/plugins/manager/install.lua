-- Plugin installation logic
local M = {}

local path_util = require("util.path")
local JobManager = require("util.job_manager")

-- Helper: Handle build phase after git operations
local function handle_build_phase(build_queue, original_callback, ui)
    if #build_queue == 0 then
        if original_callback then original_callback() end
        return
    end

    if ui then
        ui:add_line("")
        ui:add_line("🔨 Building " .. #build_queue .. " plugins...")
        ui:clear_extra_lines()
    else
        print("Starting build phase for " .. #build_queue .. " plugins...")
    end

    JobManager:reset(original_callback, ui)

    for _, plugin in ipairs(build_queue) do
        local plugin_path = path_util.get_plugin_path(plugin)

        if ui then
            ui:set_plugin_status(plugin.name, "pending", "Waiting for build...")
        else
            print("Building " .. plugin.name .. "...")
        end
        local cmd = { "sh", "-c", "cd " .. vim.fn.shellescape(plugin_path) .. " && " .. plugin.build }
        JobManager:start_job(plugin, cmd)
    end
end

-- Helper: Execute parallel git operation (install or update)
local function execute_parallel_git_operation(plugin_list, git_cmd_fn, completion_msg, callback, ui)
    if #plugin_list == 0 then
        if callback then callback() end
        return
    end

    -- Initialize UI if provided
    if ui then
        for _, plugin in ipairs(plugin_list) do
            ui:set_plugin_status(plugin.name, "pending", "Waiting...")
        end
    end

    JobManager:reset(callback, ui)
    local build_queue = {}

    for _, plugin in ipairs(plugin_list) do
        local cmd = git_cmd_fn(plugin)
        JobManager:start_job(plugin, cmd, function(p, success)
            if success and p.build then
                table.insert(build_queue, p)
            end
        end)
    end

    -- Handle builds after all operations complete
    local original_callback = JobManager.callback
    JobManager.callback = function()
        handle_build_phase(build_queue, original_callback, ui)
    end
end

-- Parallel plugin installation
function M.install_plugins_parallel(plugins_to_install, callback, ui)
    if not ui then
        for _, plugin in ipairs(plugins_to_install) do
            print("Installing " .. plugin.name .. "...")
        end
    end

    execute_parallel_git_operation(plugins_to_install, function(plugin)
        local plugin_path = path_util.get_plugin_path(plugin)
        return { "git", "clone", "--depth=1", plugin.url, plugin_path }
    end, "installation", callback, ui)
end

-- Check for missing plugins on startup and notify the user
function M.ensure_plugins_startup(plugins)
    local missing = path_util.get_missing(plugins)

    if #missing > 0 then
        vim.notify(
            "Found " .. #missing .. " missing plugins. Run ':PackInstall' to install them.",
            vim.log.levels.WARN,
            { title = "Plugin Manager" }
        )
    end
end

-- PackInstall command
function M.setup_command(plugins)
    vim.api.nvim_create_user_command("PackInstall", function()
        local missing = path_util.get_missing(plugins)

        if #missing > 0 then
            -- Create and open UI
            local PackUI = require("plugins.config.pack_ui")
            local ui = PackUI:new("PackInstall - Plugin Installation")
            ui:open()

            M.install_plugins_parallel(missing, function()
                ui:add_line("")
                ui:add_line("✅ Installed " .. #missing .. " plugins! Restart Neovim to apply changes.")
            end, ui)
        else
            print("All " .. #plugins .. " plugins already installed!")
        end
    end, {})
end

return M
