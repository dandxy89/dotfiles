-- Tmux Navigator keymaps
local keymap = require('util.keymap')
local nnoremap = keymap.bind('n')

for key, direction in pairs({ h = 'Left', j = 'Down', k = 'Up', l = 'Right' }) do
  nnoremap('<c-' .. key .. '>', '<cmd><C-U>TmuxNavigate' .. direction .. '<cr>')
end
nnoremap('<c-\\>', '<cmd><C-U>TmuxNavigatePrevious<cr>')

-- Vim Test setup
nnoremap('<Leader>t', ':TestNearest<CR>')
nnoremap('<Leader>T', ':TestFile<CR>')
nnoremap('<Leader>a', ':TestSuite<CR>')
nnoremap('<Leader>tl', ':TestLast<CR>')
nnoremap('<Leader>tv', ':TestVisit<CR>')
vim.cmd("let test#strategy = 'vimux'")
