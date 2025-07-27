vim.opt_local.expandtab = true
vim.opt_local.shiftwidth = 4
vim.opt_local.tabstop = 4
vim.opt_local.softtabstop = 4

vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
vim.cmd.inoreabbrev("<buffer> -- #")
vim.cmd.inoreabbrev("<buffer> null None")
vim.cmd.inoreabbrev("<buffer> none None")
vim.cmd.inoreabbrev("<buffer> nil None")

vim.keymap.set('n', '<leader>fl', function()
    vim.cmd('write')
    vim.cmd('!uv run ruff format %')
    vim.cmd('edit')
end, { desc = 'Save, format, and reload' })
