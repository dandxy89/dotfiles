local keymap = require('util.keymap')

-- Quality of Life stuff --
local multiremap = keymap.bind({ 'n', 's', 'v' }, { nowait = true })
multiremap('<Leader>yy', '"+y', { desc = 'Yank to clipboard' })
multiremap('<Leader>yY', '"+yy', { desc = 'Yank line to clipboard' })
multiremap('<Leader>yp', '"+p', { desc = 'Paste from clipboard' })
multiremap('<Leader>yd', '"+d', { desc = 'Delete to clipboard' })

-- NORMAL MODE
local nnoremap = keymap.bind('n', { nowait = true })
nnoremap('<Leader>w', function()
  local ok, err = pcall(vim.cmd, 'write')
  if ok then
    vim.notify('File saved')
  else
    vim.notify(tostring(err), vim.log.levels.ERROR)
  end
end, { desc = 'Save file' })
nnoremap('<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
nnoremap('<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
nnoremap('<F5>', '<cmd>UndotreeToggle<CR>', { desc = 'Toggle UndoTree' })
nnoremap('<Leader>sr', '<cmd>vs<CR>', { desc = 'Split right' })
-- Window navigation
for key in pairs({ h = true, l = true, j = true, k = true }) do
  nnoremap('<Leader>w' .. key, '<cmd>wincmd ' .. key .. '<CR>', { desc = 'Window ' .. key })
end
nnoremap('<Leader>=', '<cmd>vertical resize +10<CR>', { desc = 'Resize wider' })
nnoremap('<Leader>-', '<cmd>vertical resize -10<CR>', { desc = 'Resize thinner' })
nnoremap('<Leader>rh', '<cmd>nohl<CR>', { desc = 'Remove highlight' })
nnoremap('<F9>', '<cmd>!python %<CR>', { desc = 'Run Python' })
nnoremap('<C-a>', 'gg<S-v>G', { desc = 'Select all' })
nnoremap('x', '"_x', { desc = 'Delete char (no register)' })
local function smart_dd()
  if vim.api.nvim_get_current_line():match('^%s*$') then
    return '"_dd'
  else
    return 'dd'
  end
end
nnoremap('dd', smart_dd, { expr = true, desc = 'Smart delete line' })
nnoremap('<Leader>nf', '<cmd>enew<CR>', { desc = 'New file' })
nnoremap('<Leader>e', '<cmd>Fyler<CR>', { desc = 'File manager' })
nnoremap('<Leader>ec', '<cmd>tabnew ~/.config/nvim/init.lua<CR>', { desc = 'Edit Config (init.lua)' })
nnoremap('<Leader>cn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
nnoremap('<C-Z>', '<cmd>undo<CR>', { desc = 'Undo' })
nnoremap('<C-Y>', '<cmd>redo<CR>', { desc = 'Redo' })
nnoremap('<Leader>fl', function()
  if vim.bo.filetype == 'json' or vim.bo.filetype == 'jsonc' then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    local ok = pcall(vim.cmd, '%!jq .')
    if not ok then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.notify('jq formatting failed', vim.log.levels.ERROR)
    end
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format code' })
nnoremap('<Leader>de', vim.diagnostic.open_float, { desc = 'Open diagnostics float' })
nnoremap('<BS>', '<C-o>', { desc = 'Jump back' })
nnoremap('K', vim.lsp.buf.hover, { desc = 'Hover info' })
nnoremap('<Leader>gd', vim.lsp.buf.declaration, { desc = 'Go to declaration' })
nnoremap('[d', function()
  vim.diagnostic.jump({ count = -1 })
end, { desc = 'Previous diagnostic' })
nnoremap(']d', function()
  vim.diagnostic.jump({ count = 1 })
end, { desc = 'Next diagnostic' })
nnoremap(']q', '<cmd>cnext<CR>', { desc = 'Quickfix next' })
nnoremap('[q', '<cmd>cprevious<CR>', { desc = 'Quickfix previous' })

-- Buffer management (C-h/j/k/l handled by tmux navigator in pack.lua)
nnoremap('<Leader>bd', function()
  require('snacks').bufdelete()
end, { desc = 'Delete buffer' })
nnoremap('<Leader><Tab>', '<C-^>', { desc = 'Toggle last buffer' })
nnoremap('<Leader>ll', function()
  vim.cmd.match(string.format('Visual /%s/', vim.fn.escape(vim.fn.expand('<cword>'), '/\\.*[]~')))
end, { desc = 'Highlight word under cursor' })

-- VISUAL MODE
local vnoremap = keymap.bind('v', { nowait = true })
vnoremap('K', "<cmd>m '>-2<CR>gv=gv", { desc = 'Move line up' })
vnoremap('J', "<cmd>m '>+1<CR>gv=gv", { desc = 'Move line down' })
nnoremap('<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
nnoremap('<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
vnoremap('<Leader>r', '"hy:%s/<C-r>h//g<left><left>', { desc = 'Replace selection' })
vnoremap('<Leader>R', function()
  vim.cmd('normal! "vy')
  local cmd = vim.fn.getreg('v')
  local confirm = vim.fn.confirm('Run: ' .. cmd, '&Yes\n&No', 2)
  if confirm == 1 then
    vim.cmd('new')
    vim.cmd('read !' .. cmd)
  end
end, { desc = 'Run selection as shell command' })

-- Better indenting
vnoremap('<', '<gv', { desc = 'Indent left' })
vnoremap('>', '>gv', { desc = 'Indent right' })

-- INSERT MODE
local inoremap = keymap.bind('i', { nowait = true })
inoremap('<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file' })

-- TERMINAL MODE
local tnoremap = keymap.bind('t', { nowait = true })
tnoremap('<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

-- LEAP (motion plugin)
vim.keymap.set({ 'n', 'x', 'o' }, 's', '<Plug>(leap)', { desc = 'Leap forward' })
vim.keymap.set('n', 'S', '<Plug>(leap-from-window)', { desc = 'Leap from window' })

-- Vim Test
nnoremap('<Leader>t', ':TestNearest<CR>', { desc = 'Test nearest' })
nnoremap('<Leader>T', ':TestFile<CR>', { desc = 'Test file' })
nnoremap('<Leader>a', ':TestSuite<CR>', { desc = 'Test suite' })
nnoremap('<Leader>tl', ':TestLast<CR>', { desc = 'Test last' })
nnoremap('<Leader>tv', ':TestVisit<CR>', { desc = 'Test visit' })

-- Package management
nnoremap('<Leader>pu', '<cmd>PackUpdate<CR>', { desc = 'Update plugins' })
