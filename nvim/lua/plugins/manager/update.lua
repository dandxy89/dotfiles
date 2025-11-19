-- Plugin update logic
local M = {}

local path_util = require('util.path')
local install = require('plugins.manager.install')

-- Parallel update system
function M.update_plugins_parallel(plugins)
  local existing_plugins = path_util.get_existing(plugins)

  if #existing_plugins == 0 then
    print('No plugins found to update!')
    return
  end

  -- Create and open UI
  local PackUI = require('plugins.config.pack_ui')
  local ui = PackUI:new('PackUpdate - Plugin Updates')
  ui:open()

  -- Use the shared install helper for git operations
  local execute_parallel_git_operation = function(plugin_list, git_cmd_fn, completion_msg, callback, ui_inst)
    local JobManager = require('util.job_manager')

    if #plugin_list == 0 then
      if callback then
        callback()
      end
      return
    end

    -- Initialize UI if provided
    if ui_inst then
      for _, plugin in ipairs(plugin_list) do
        ui_inst:set_plugin_status(plugin.name, 'pending', 'Waiting...')
      end
    end

    JobManager:reset(callback, ui_inst)
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
      if #build_queue == 0 then
        if original_callback then
          original_callback()
        end
        return
      end

      if ui_inst then
        ui_inst:add_line('')
        ui_inst:add_line('🔨 Rebuilding ' .. #build_queue .. ' updated plugins...')
        ui_inst:clear_extra_lines()
      else
        print('Starting build phase for ' .. #build_queue .. ' plugins...')
      end

      JobManager:reset(original_callback, ui_inst)

      for _, plugin in ipairs(build_queue) do
        local plugin_path = path_util.get_plugin_path(plugin)

        if ui_inst then
          ui_inst:set_plugin_status(plugin.name, 'pending', 'Waiting for build...')
        else
          print('Building ' .. plugin.name .. '...')
        end
        local cmd = { 'sh', '-c', 'cd ' .. vim.fn.shellescape(plugin_path) .. ' && ' .. plugin.build }
        JobManager:start_job(plugin, cmd)
      end
    end
  end

  execute_parallel_git_operation(
    existing_plugins,
    function(plugin)
      local plugin_path = path_util.get_plugin_path(plugin)
      return {
        'sh',
        '-c',
        'cd '
          .. vim.fn.shellescape(plugin_path)
          .. ' && git fetch --all'
          .. ' && OLD=$(git rev-parse --short HEAD)'
          .. ' && git pull --ff-only'
          .. ' && NEW=$(git rev-parse --short HEAD)'
          .. ' && if [ "$OLD" != "$NEW" ]; then'
          .. '   echo "Updated: $OLD → $NEW";'
          .. '   git log --oneline --no-decorate $OLD..$NEW;'
          .. ' else'
          .. '   echo "Already up-to-date at $OLD";'
          .. ' fi',
      }
    end,
    'update',
    function()
      ui:add_line('')
      ui:add_line('✅ All plugin updates completed! Restart Neovim to apply changes.')
    end,
    ui
  )
end

-- PackUpdate command
function M.setup_command(plugins)
  vim.api.nvim_create_user_command('PackUpdate', function()
    M.update_plugins_parallel(plugins)
  end, {})
end

return M
