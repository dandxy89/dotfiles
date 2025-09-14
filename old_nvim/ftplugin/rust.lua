require("ferris").setup({})

local keymap = vim.keymap.set
keymap("n", "<Leader>ml", ':lua require("ferris.methods.view_memory_layout")()<CR>')
keymap("n", "<Leader>em", ':lua require("ferris.methods.expand_macro")()<CR>')
keymap("n", "<Leader>od", ':lua require("ferris.methods.open_documentation")()<CR>')

vim.keymap.set('n', '<leader>fl', function()
    vim.cmd('write')
    vim.cmd('!cargo fmt')
    vim.cmd('edit')
end, { desc = 'Save, format, and reload' })
