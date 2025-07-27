vim.opt_local.wrap = true
vim.opt_local.spell = false

vim.keymap.set('n', '<leader>fl', function()
    vim.cmd('write')
    vim.cmd('!jq . % > /tmp/jq_temp && mv /tmp/jq_temp %')
    vim.cmd('edit')
end, { desc = 'Save, format, and reload' })
