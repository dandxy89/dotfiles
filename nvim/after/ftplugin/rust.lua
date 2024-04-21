--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Rust                               ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

vim.cmd.inoreabbrev("<buffer> true True")
vim.cmd.inoreabbrev("<buffer> false False")
vim.cmd.inoreabbrev("<buffer> -- //")

-- Override mini-pairs
vim.keymap.set('i', "'", "'", { buffer = 0 })

-- Import ferris.nvim 🦀
require("ferris")

-- Keymaps
local keymap = vim.keymap.set
keymap('n', '<Leader>ml', ':lua require("ferris.methods.view_memory_layout")()<CR>')
keymap('n', '<Leader>em', ':lua require("ferris.methods.expand_macro")()<CR>')
keymap('n', '<Leader>od', ':lua require("ferris.methods.open_documentation")()<CR>')
