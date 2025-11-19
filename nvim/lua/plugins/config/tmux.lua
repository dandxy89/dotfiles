-- Tmux Navigator keymaps
local keymap = require('util.keymap')
local nnoremap = keymap.bind('n')

for key, direction in pairs({ h = 'Left', j = 'Down', k = 'Up', l = 'Right' }) do
  nnoremap('<c-' .. key .. '>', '<cmd>TmuxNavigate' .. direction .. '<CR>')
end
nnoremap('<c-\\>', '<cmd>TmuxNavigatePrevious<CR>')
