local map = vim.keymap.set

map('n', '<Leader>w', function()
  local ok, err = pcall(vim.cmd.write)
  vim.notify(ok and 'File saved' or tostring(err), ok and vim.log.levels.INFO or vim.log.levels.ERROR)
end, { desc = 'Save file' })
map('n', '<Tab>', '<cmd>bnext<CR>', { desc = 'Next buffer' })
map('n', '<S-Tab>', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
map('n', '<Leader>sr', '<cmd>vs<CR>', { desc = 'Split right' })
map('n', '<Leader>=', '<cmd>vertical resize +10<CR>', { desc = 'Resize wider' })
map('n', '<Leader>-', '<cmd>vertical resize -10<CR>', { desc = 'Resize thinner' })
map('n', '<Leader>rh', '<cmd>nohl<CR>', { desc = 'Remove highlight' })
map('n', '<F9>', '<cmd>!uv run %<CR>', { desc = 'Run Python (uv)' })
map('n', '<C-a>', 'gg<S-v>G', { desc = 'Select all' })
map('n', 'x', '"_x', { desc = 'Delete char (no register)' })
map('n', 'dd', function()
  return vim.api.nvim_get_current_line():match('^%s*$') and '"_dd' or 'dd'
end, { expr = true, desc = 'Smart delete line' })
map('n', '<Leader>fn', '<cmd>enew<CR>', { desc = 'New file' })
map('n', '<Leader>e', '<cmd>edit .<CR>', { desc = 'Browse cwd (native dir)' })
map('n', '<Leader>ec', '<cmd>tabnew ~/.config/nvim/init.lua<CR>', { desc = 'Edit Config (init.lua)' })
map('n', '<Leader>cn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
map('n', '<Leader>cl', vim.lsp.codelens.run, { desc = 'Run codelens' })
map('n', '<Leader>cL', function()
  vim.lsp.codelens.enable(not vim.lsp.codelens.is_enabled())
end, { desc = 'Toggle codelens' })
map('n', '<Leader>fl', function()
  if vim.bo.filetype == 'json' or vim.bo.filetype == 'jsonc' then
    local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
    if
      not pcall(vim.cmd --[[@as fun(cmd: string)]], '%!jq .')
    then
      vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
      vim.notify('jq formatting failed', vim.log.levels.ERROR)
    end
  else
    vim.lsp.buf.format()
  end
end, { desc = 'Format code' })
map('n', '<Leader>de', vim.diagnostic.open_float, { desc = 'Open diagnostics float' })
map('n', '<BS>', '<C-o>', { desc = 'Jump back' })
map('n', ']q', '<cmd>cnext<CR>', { desc = 'Quickfix next' })
map('n', '[q', '<cmd>cprevious<CR>', { desc = 'Quickfix previous' })
map('n', '<Leader>n', '<cmd>messages<CR>', { desc = 'Message history' })

for key, pane in pairs({ h = 'L', j = 'D', k = 'U', l = 'R' }) do
  map('n', '<C-' .. key .. '>', function()
    local from = vim.api.nvim_get_current_win()
    vim.cmd.wincmd(key)
    if from == vim.api.nvim_get_current_win() and vim.env.TMUX then
      vim.system({ 'tmux', 'select-pane', '-' .. pane })
    end
  end, { silent = true, desc = 'Window/tmux ' .. pane })
end

map('n', '<Leader>bd', function()
  if
    not pcall(vim.cmd --[[@as fun(cmd: string)]], 'bprevious | bdelete #')
  then
    vim.cmd.bdelete()
  end
end, { desc = 'Delete buffer' })
map('n', '<Leader><Tab>', '<C-^>', { desc = 'Toggle last buffer' })
map('n', '<Leader>ll', function()
  vim.cmd.match(string.format('Visual /%s/', vim.fn.escape(vim.fn.expand('<cword>'), '/\\.*[]~')))
end, { desc = 'Highlight word under cursor' })

local term = require('util.term')
map('n', '<Leader>.', function()
  term.toggle(vim.o.shell, 'bottom')
end, { desc = 'Terminal' })
map('n', '<Leader>k', function()
  term.toggle('kiro-cli chat --v3', 'right')
end, { desc = 'Kiro CLI' })
map('n', '<Leader>lg', function()
  term.toggle('lazygit', 'tab')
end, { desc = 'Lazygit' })
map('n', '<Leader>gf', function()
  term.toggle('lazygit -f ' .. vim.fn.shellescape(vim.fn.expand('%')), 'tab')
end, { desc = 'Git log file' })

map('v', 'K', "<cmd>m '>-2<CR>gv=gv", { desc = 'Move line up' })
map('v', 'J', "<cmd>m '>+1<CR>gv=gv", { desc = 'Move line down' })
map('n', '<M-k>', ':m .-2<CR>==', { desc = 'Move line up' })
map('n', '<M-j>', ':m .+1<CR>==', { desc = 'Move line down' })
map('v', '<Leader>r', '"hy:%s/<C-r>h//g<left><left>', { desc = 'Replace selection' })
map('v', '<Leader>R', function()
  vim.cmd('normal! "vy')
  local cmd = vim.fn.getreg('v')
  if vim.fn.confirm('Run: ' .. cmd, '&Yes\n&No', 2) == 1 then
    vim.cmd('new')
    vim.cmd('read !' .. cmd)
  end
end, { desc = 'Run selection as shell command' })
map('v', '<', '<gv', { desc = 'Indent left' })
map('v', '>', '>gv', { desc = 'Indent right' })

map('i', '<C-s>', '<Esc><cmd>w<CR>', { desc = 'Save file' })
map('i', '<Tab>', function()
  local col = vim.fn.col('.')
  return vim.api.nvim_get_current_line():sub(col, col):match('[%)%]}>"\'`]') and '<Right>' or '<Tab>'
end, { expr = true })

map('t', '<Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

for lhs, kind in pairs({ ['<Leader>tn'] = 'nearest', ['<Leader>T'] = 'file', ['<Leader>a'] = 'suite', ['<Leader>tl'] = 'last' }) do
  map('n', lhs, function()
    require('util.test').run(kind)
  end, { desc = 'Test ' .. kind })
end

map('n', '<Leader>qq', '<cmd>qa<CR>', { desc = 'Quit all' })
map('n', '<Leader>pu', '<cmd>packupdate<CR>', { desc = 'Update plugins' })
