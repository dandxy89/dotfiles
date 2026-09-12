vim.bo.commentstring = '\\ %s'
vim.keymap.set('n', '<Leader>mr', function()
  vim.cmd('botright 15split')
  vim.cmd.terminal('highs --solution_file /dev/stdout ' .. vim.fn.shellescape(vim.fn.expand('%:p')))
end, { buffer = 0, desc = 'Solve with HiGHS' })
