-- Tmux Navigator keymaps
local opts = { noremap = true, silent = true }
for key, direction in pairs({ h = "Left", j = "Down", k = "Up", l = "Right" }) do
    vim.keymap.set("n", "<c-" .. key .. ">", "<cmd><C-U>TmuxNavigate" .. direction .. "<cr>", opts)
end
vim.keymap.set("n", "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>", opts)

-- Vim Test setup
vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>", {})
vim.keymap.set("n", "<Leader>T", ":TestFile<CR>", {})
vim.keymap.set("n", "<Leader>a", ":TestSuite<CR>", {})
vim.keymap.set("n", "<Leader>l", ":TestLast<CR>", {})
vim.keymap.set("n", "<Leader>g", ":TestVisit<CR>", {})
vim.cmd("let test#strategy = 'vimux'")

