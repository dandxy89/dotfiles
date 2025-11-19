-- Shared utility for format-reload pattern
local M = {}

-- Execute format command on current file: save, format, reload
function M.format_reload(cmd, desc)
    vim.keymap.set('n', '<leader>fl', function()
        vim.cmd('write')
        vim.cmd(cmd)
        vim.cmd('edit')
    end, { desc = desc or 'Save, format, and reload', buffer = true })
end

return M
