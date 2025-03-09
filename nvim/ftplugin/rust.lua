require("ferris").setup({})

local keymap = vim.keymap.set
keymap("n", "<Leader>ml", ':lua require("ferris.methods.view_memory_layout")()<CR>')
keymap("n", "<Leader>em", ':lua require("ferris.methods.expand_macro")()<CR>')
keymap("n", "<Leader>od", ':lua require("ferris.methods.open_documentation")()<CR>')
