vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({ extension = { lp = 'lp', mps = 'mps' } })
-- Grammar lives in dandxy89/treesitter-lp; bump `revision` then run :TSUpdate lp
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').lp = {
      tier = 3,
      install_info = {
        url = 'https://github.com/dandxy89/treesitter-lp',
        revision = '7b212e7c585fc4208d0371d4338afd1f8fb61ef1',
        queries = 'queries',
      },
    }
  end,
})

require('core.opts')
require('plugins')
require('core.autocmds')
require('core.keys')
require('core.lsp')
require('statusline')
