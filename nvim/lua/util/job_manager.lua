-- Parallel job manager for plugin operations
local JobManager = {
  jobs = {},
  completed = 0,
  total = 0,
  callback = nil,
  ui = nil, -- Optional UI instance for visual feedback
}

function JobManager:start_job(plugin, cmd, on_complete)
  self.total = self.total + 1

  -- Notify UI that job is starting
  if self.ui then
    self.ui:set_plugin_status(plugin.name, 'running', 'In progress...')
    self.ui:set_progress(self.completed, self.total)
  end

  local job_id = vim.fn.jobstart(cmd, {
    on_exit = function(_, exit_code)
      self.completed = self.completed + 1
      if exit_code == 0 then
        if self.ui then
          self.ui:set_plugin_status(plugin.name, 'success', 'Completed')
          self.ui:set_progress(self.completed, self.total)
        else
          print('✓ ' .. plugin.name .. ' completed')
        end
        if on_complete then
          on_complete(plugin, true)
        end
      else
        if self.ui then
          self.ui:set_plugin_status(plugin.name, 'error', 'Failed')
          self.ui:set_progress(self.completed, self.total)
        else
          print('✗ ' .. plugin.name .. ' failed')
        end
        if on_complete then
          on_complete(plugin, false)
        end
      end

      if self.completed >= self.total and self.callback then
        self.callback()
      end
    end,
    on_stdout = function(_, data)
      if data and #data > 0 then
        for _, line in ipairs(data) do
          if line ~= '' then
            if self.ui then
              self.ui:set_plugin_status(plugin.name, 'running', line)
            else
              print(plugin.name .. ': ' .. line)
            end
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if data and #data > 0 then
        for _, line in ipairs(data) do
          if line ~= '' then
            if self.ui then
              self.ui:set_plugin_status(plugin.name, 'running', '(err) ' .. line)
            else
              print(plugin.name .. ' (err): ' .. line)
            end
          end
        end
      end
    end,
  })

  self.jobs[job_id] = plugin
end

function JobManager:reset(callback, ui)
  self.jobs = {}
  self.completed = 0
  self.total = 0
  self.callback = callback
  self.ui = ui
end

return JobManager
