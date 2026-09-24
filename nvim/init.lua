vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({ extension = { lp = 'lp', mps = 'mps' } })
-- Vendored grammar (synced via `make nvim-sync` in tree-sitter-lp); queries live in queries/lp
vim.api.nvim_create_autocmd('User', {
  pattern = 'TSUpdate',
  callback = function()
    require('nvim-treesitter.parsers').lp = {
      install_info = { path = vim.fn.stdpath('config') .. '/tree-sitter-lp' },
    }
  end,
})

require('core.opts')
require('plugins')
require('core.autocmds')
require('core.keys')
require('core.lsp')
require('statusline')
