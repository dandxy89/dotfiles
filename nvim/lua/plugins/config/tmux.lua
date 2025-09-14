-- Tmux Navigator keymaps
local opts = { noremap = true, silent = true }
vim.keymap.set("n", "<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>", opts)
vim.keymap.set("n", "<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>", opts)
vim.keymap.set("n", "<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>", opts)
vim.keymap.set("n", "<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>", opts)
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", opts)

-- Vim Test setup
vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>", {})
vim.keymap.set("n", "<Leader>T", ":TestFile<CR>", {})
vim.keymap.set("n", "<Leader>a", ":TestSuite<CR>", {})
vim.keymap.set("n", "<Leader>l", ":TestLast<CR>", {})
vim.keymap.set("n", "<Leader>g", ":TestVisit<CR>", {})
vim.cmd("let test#strategy = 'vimux'")

