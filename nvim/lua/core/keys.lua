local keymap = require('util.keymap')

-- Quality of Life stuff --
local multiremap = keymap.bind({ 'n', 's', 'v' }, { nowait = true })
multiremap('<Leader>yy', '"+y')
multiremap('<Leader>yY', '"+yy')
multiremap('<Leader>yp', '"+p')
multiremap('<Leader>yd', '"+d')

-- NORMAL MODE
local nnoremap = keymap.bind('n', { nowait = true })
nnoremap('<Leader>w', function()
  vim.cmd('silent! write!')
  vim.notify('File saved')
end) -- Save file
nnoremap('<Tab>', '<cmd>bnext<CR>') -- Next buffer
nnoremap('<S-Tab>', '<cmd>bprevious<CR>') -- Previous buffer
nnoremap('<F5>', '<cmd>UndotreeToggle<CR>') -- Toggle UndoTree
nnoremap('<Leader>sr', '<cmd>vs<CR>') -- Split right
-- Window navigation
for key in pairs({ h = true, l = true, j = true, k = true }) do
  nnoremap('<Leader>w' .. key, '<cmd>wincmd ' .. key .. '<CR>')
end
nnoremap('<Leader>=', '<cmd>vertical resize +10<CR>') -- Resize thinner
nnoremap('<Leader>-', '<cmd>vertical resize -10<CR>') -- Resize wider
nnoremap('<Leader>rh', '<cmd>nohl<CR>') -- Remove highlight
nnoremap('<F9>', '<cmd>!python %<CR>') -- Run Python
nnoremap('<C-a>', 'gg<S-v>G') -- Select all
nnoremap('x', '"_x') -- No map x
local function smart_dd()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return '"_dd'
  else
    return 'dd'
  end
end
nnoremap('dd', smart_dd, { expr = true })
nnoremap('<Leader>nf', '<cmd>enew<CR>') -- New file
nnoremap('<Leader>e', '<cmd>Fyler<CR>') -- Open file manager
nnoremap('<Leader>ec', '<cmd>tabnew ~/.config/nvim/init.lua<CR>', { desc = 'Edit Config (init.lua)' })
nnoremap('<Leader>cn', vim.lsp.buf.rename) -- Rename
nnoremap('<C-Z>', '<cmd>undo<CR>') -- Undo
nnoremap('<C-Y>', '<cmd>redo<CR>') -- Redo
nnoremap('<Leader>fl', function()
  if vim.bo.filetype == 'json' or vim.bo.filetype == 'jsonc' then
    vim.cmd('%!jq .')
  else
    vim.lsp.buf.format()
  end
end) -- Format code
nnoremap('<Leader>de', vim.diagnostic.open_float) -- Open diagnostics
nnoremap('<BS>', '<C-o>') -- Backspace jump
nnoremap('K', vim.lsp.buf.hover) -- Hover
nnoremap('<Leader>gd', vim.lsp.buf.declaration) -- Declaration
nnoremap('[d', function()
  vim.diagnostic.jump({ count = -1 })
end) -- Previous diagnostic
nnoremap(']d', function()
  vim.diagnostic.jump({ count = 1 })
end) -- Next diagnostic
nnoremap(']q', '<cmd>cnext<CR>') -- Quickfix next
nnoremap('[q', '<cmd>cprevious<CR>') -- Quickfix previous

-- Buffer management (C-h/j/k/l handled by tmux navigator in pack.lua)
nnoremap('<Leader>bd', function()
  require('snacks').bufdelete()
end) -- Close buffer
nnoremap('<Leader><Tab>', '<C-^>') -- Toggle buffers
nnoremap('<Leader>ll', function()
  vim.cmd.match(string.format('Visual /%s/', vim.fn.expand('<cword>')))
end) -- Highlight word under cursor

-- VISUAL MODE
local vnoremap = keymap.bind('v', { nowait = true })
vnoremap('K', "<cmd>m '>-2<CR>gv=gv") -- Move line up
vnoremap('J', "<cmd>m '>+1<CR>gv=gv") -- Move line down
nnoremap('<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
nnoremap('<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vnoremap('<Leader>r', '"hy:%s/<C-r>h//g<left><left>') -- Replace selection
vnoremap('<Leader>R', function()
  vim.cmd('normal! "vy')
  local cmd = vim.fn.getreg('v')
  vim.cmd('new')
  vim.cmd('read !' .. cmd)
end) -- Run selection as shell command

-- Better indenting
vnoremap('<', '<gv')
vnoremap('>', '>gv')

-- INSERT MODE
local inoremap = keymap.bind('i', { nowait = true })
inoremap('<C-s>', '<Esc><cmd>w<CR>') -- Save file

-- TERMINAL MODE
local tnoremap = keymap.bind('t', { nowait = true })
tnoremap('<Esc>', '<C-\\><C-n>') -- Exit terminal

-- LEAP (motion plugin)
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'Leap forward' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap from window' })

-- Vim Test
nnoremap('<Leader>t', ':TestNearest<CR>')
nnoremap('<Leader>T', ':TestFile<CR>')
nnoremap('<Leader>a', ':TestSuite<CR>')
nnoremap('<Leader>tl', ':TestLast<CR>')
nnoremap('<Leader>tv', ':TestVisit<CR>')

-- Package management
nnoremap('<Leader>pu', '<cmd>PackUpdate<CR>', { desc = 'Update plugins' })
