return {
  { 'preservim/vimux' },

  {
    'vim-test/vim-test',
    dependencies = { 'vimux' },
    cmd = { 'TestNearest', 'TestFile', 'TestSuite', 'TestLast', 'TestVisit' },
    init = function()
      vim.g['test#strategy'] = 'vimux'
      vim.g['test#python#runner'] = 'pytest'
    end,
  },
}
