-- Parallel job manager for plugin operations
local JobManager = {
    jobs = {},
    completed = 0,
    total = 0,
    callback = nil
}

function JobManager:start_job(plugin, cmd, on_complete)
    self.total = self.total + 1

    local job_id = vim.fn.jobstart(cmd, {
        on_exit = function(_, exit_code)
            self.completed = self.completed + 1
            if exit_code == 0 then
                print("✓ " .. plugin.name .. " completed")
                if on_complete then on_complete(plugin, true) end
            else
                print("✗ " .. plugin.name .. " failed")
                if on_complete then on_complete(plugin, false) end
            end

            if self.completed >= self.total and self.callback then
                self.callback()
            end
        end,
        on_stdout = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(plugin.name .. ": " .. line)
                    end
                end
            end
        end,
        on_stderr = function(_, data)
            if data and #data > 0 then
                for _, line in ipairs(data) do
                    if line ~= "" then
                        print(plugin.name .. " (err): " .. line)
                    end
                end
            end
        end
    })

    self.jobs[job_id] = plugin
end

function JobManager:reset(callback)
    self.jobs = {}
    self.completed = 0
    self.total = 0
    self.callback = callback
end

return JobManager
