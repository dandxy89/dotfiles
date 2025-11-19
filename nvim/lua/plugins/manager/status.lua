-- Plugin status and cleanup logic
local M = {}

local path_util = require("util.path")

-- Helper: Scan for orphaned plugins
local function scan_orphaned_plugins(plugins)
    local valid_plugins = {}
    for _, plugin in ipairs(plugins) do
        valid_plugins[plugin.name] = true
    end

    local orphaned = {}
    for _, base_path in ipairs({ path_util.start_path, path_util.opt_path }) do
        local handle = vim.uv.fs_scandir(base_path)
        if handle then
            while true do
                local name, type = vim.uv.fs_scandir_next(handle)
                if not name then break end

                if type == "directory" and not valid_plugins[name] then
                    table.insert(orphaned, {
                        name = name,
                        path = base_path .. "/" .. name,
                        location = base_path == path_util.start_path and "start" or "opt"
                    })
                end
            end
        end
    end
    return orphaned
end

-- Helper: Build plugin list content lines
local function build_plugin_list(plugins, show_unloaded)
    local content_lines = {}

    -- Core plugins section
    local core_count = 0
    for _, plugin in ipairs(plugins) do
        if not plugin.opt then
            if core_count == 0 then
                local header_line = show_unloaded and "╭─ 📦 Core Plugins (Always Loaded) " or "╭─ 📦 Core Plugins "
                table.insert(content_lines, { text = header_line .. string.rep("─", 30), hl_group = "FloatBorder" })
            end
            core_count = core_count + 1
            local icon = show_unloaded and "  📦" or "  🟢"
            table.insert(content_lines, { text = icon .. "  " .. plugin.name, hl_group = "DiagnosticOk" })
        end
    end

    if core_count > 0 then
        table.insert(content_lines, { text = "╰" .. string.rep("─", 65), hl_group = "FloatBorder" })
    end

    -- Lazy loaded plugins section
    local groups = {}
    for _, plugin in ipairs(plugins) do
        if plugin.opt then
            local trigger = plugin.trigger or "manual"
            if not groups[trigger] then
                groups[trigger] = {}
            end
            table.insert(groups[trigger], plugin)
        end
    end

    local lazy_count = 0
    if show_unloaded then
        table.insert(content_lines, { text = "", hl_group = "Normal" })
        table.insert(content_lines, { text = "╭─ ⚡ Lazy-Loaded Plugins " .. string.rep("─", 37), hl_group = "FloatBorder" })

        for trigger, group_plugins in pairs(groups) do
            table.insert(content_lines, { text = "", hl_group = "Normal" })
            table.insert(content_lines, { text = "  │ Trigger: " .. trigger, hl_group = "Special" })
            table.insert(content_lines, { text = "  ├" .. string.rep("─", 60), hl_group = "FloatBorder" })
            for _, plugin in ipairs(group_plugins) do
                local loaded = package.loaded[plugin.name:gsub("%.nvim$", "")] ~= nil
                local icon = loaded and "🟢" or "⚪"
                local status = loaded and " [loaded]" or " [not loaded]"
                local hl = loaded and "DiagnosticOk" or "Comment"
                table.insert(content_lines, { text = string.format("  │   %s  %s%s", icon, plugin.name, status), hl_group = hl })
                if loaded then lazy_count = lazy_count + 1 end
            end
        end
        table.insert(content_lines, { text = "╰" .. string.rep("─", 65), hl_group = "FloatBorder" })
    else
        -- Only show loaded lazy plugins
        local loaded_lazy = {}
        for _, plugin in ipairs(plugins) do
            if plugin.opt then
                local module_name = plugin.name:gsub("%.nvim$", ""):gsub("%-", "_")
                if package.loaded[module_name] or package.loaded[plugin.name:gsub("%.nvim$", "")] then
                    lazy_count = lazy_count + 1
                    table.insert(loaded_lazy, plugin)
                end
            end
        end

        if #loaded_lazy > 0 then
            table.insert(content_lines, { text = "", hl_group = "Normal" })
            table.insert(content_lines, { text = "╭─ ⚡ Lazy-Loaded Plugins (Active) " .. string.rep("─", 28), hl_group = "FloatBorder" })
            for _, plugin in ipairs(loaded_lazy) do
                local trigger = plugin.trigger or "manual"
                table.insert(content_lines, { text = string.format("  │ 🟢  %s  │  trigger: %s", plugin.name, trigger), hl_group = "DiagnosticOk" })
            end
            table.insert(content_lines, { text = "╰" .. string.rep("─", 65), hl_group = "FloatBorder" })
        end
    end

    return content_lines, core_count, lazy_count
end

-- Clean orphaned plugins
local function clean_plugins(plugins)
    local orphaned = scan_orphaned_plugins(plugins)

    if #orphaned == 0 then
        print("✨ No orphaned plugins found. All clean!")
        return
    end

    -- Create UI to display orphaned plugins
    local PackUI = require("plugins.config.pack_ui")
    local ui = PackUI:new("PackClean - Removing Orphaned Plugins")
    ui:open()

    ui:add_line("Found " .. #orphaned .. " orphaned plugin(s):")
    ui:add_line("")

    for _, plugin in ipairs(orphaned) do
        ui:add_line("  • " .. plugin.name .. " [" .. plugin.location .. "]")
    end

    ui:add_line("")
    ui:add_line("Deleting orphaned plugins...")
    ui:add_line("")

    -- Delete each orphaned plugin
    local deleted_count = 0
    for _, plugin in ipairs(orphaned) do
        ui:add_line("Deleting: " .. plugin.name)

        local success = vim.fn.delete(plugin.path, "rf")
        if success ~= 0 then
            ui:add_line("❌ Error deleting " .. plugin.name)
            ui:add_line("")
            ui:add_line("Cleanup stopped due to error.")
            return
        end

        deleted_count = deleted_count + 1
    end

    ui:add_line("")
    ui:add_line("✅ Successfully removed " .. deleted_count .. " orphaned plugin(s)!")
end

-- Setup status commands
function M.setup_commands(plugins)
    -- PackStatus command (supports 'all' or 'active' view)
    vim.api.nvim_create_user_command("PackStatus", function(args)
        local view = args.args == "" and "all" or args.args

        if view ~= "all" and view ~= "active" then
            print("Invalid argument. Use :PackStatus [all|active]")
            return
        end

        local show_all = view == "all"
        local PackUI = require("plugins.config.pack_ui")
        local title = show_all and "PackStatus - All Plugins" or "PackStatus - Active Plugins"
        local ui = PackUI:new(title)
        ui:open()

        local content_lines, core_count, lazy_count = build_plugin_list(plugins, show_all)

        -- Orphaned plugins section (only in 'all' view)
        if show_all then
            local orphaned = scan_orphaned_plugins(plugins)
            if #orphaned > 0 then
                table.insert(content_lines, { text = "", hl_group = "Normal" })
                table.insert(content_lines, { text = "╭─ ⚠️  Orphaned Plugins (Not in Config) " .. string.rep("─", 22), hl_group = "FloatBorder" })
                for _, plugin in ipairs(orphaned) do
                    table.insert(content_lines, { text = string.format("  │ 🔴  %s  [%s]", plugin.name, plugin.location), hl_group = "DiagnosticWarn" })
                end
                table.insert(content_lines, { text = "  ├" .. string.rep("─", 60), hl_group = "FloatBorder" })
                table.insert(content_lines, { text = "  │ 💡 Run :PackClean to remove these plugins", hl_group = "Comment" })
                table.insert(content_lines, { text = "╰" .. string.rep("─", 65), hl_group = "FloatBorder" })
            end
        end

        -- Summary (always show)
        table.insert(content_lines, { text = "", hl_group = "Normal" })
        table.insert(content_lines, { text = "╭─ 📊 Summary " .. string.rep("─", 50), hl_group = "FloatBorder" })

        if show_all then
            table.insert(content_lines, { text = string.format("  │ Total plugins: %d", #plugins), hl_group = "Special" })
            table.insert(content_lines, { text = string.format("  │ Core plugins: %d", core_count), hl_group = "Normal" })
            table.insert(content_lines, { text = string.format("  │ Lazy plugins: %d (%d loaded)", lazy_count, lazy_count), hl_group = "Normal" })
        else
            local active_count = core_count + lazy_count
            table.insert(content_lines, { text = string.format("  │ Active plugins: %d/%d", active_count, #plugins), hl_group = "Special" })
            table.insert(content_lines, { text = string.format("  │ Core: %d  │  Lazy-loaded: %d", core_count, lazy_count), hl_group = "Normal" })
        end

        -- Memory usage (always show)
        if vim.fn.has('nvim-0.9') == 1 then
            local mem = vim.fn.luaeval('collectgarbage("count")')
            table.insert(content_lines, { text = string.format("  │ Lua memory: %.2f MB", mem / 1024), hl_group = "Comment" })
        end

        table.insert(content_lines, { text = "╰" .. string.rep("─", 65), hl_group = "FloatBorder" })

        ui:display_static(content_lines)
    end, { nargs = '?', desc = "Show plugin status (use 'all' or 'active')" })

    -- PackClean command
    vim.api.nvim_create_user_command("PackClean", function()
        clean_plugins(plugins)
    end, { desc = "Remove orphaned plugins not defined in plugins table" })
end

return M
