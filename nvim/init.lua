vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

vim.filetype.add({ extension = { lp = 'lp', mps = 'mps' } })
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'lp',
  once = true,
  callback = function()
    local parser = vim.fn.expand('~/Projects/tree-sitter-lp/parser.so')
    if vim.uv.fs_stat(parser) then
      vim.treesitter.language.add('lp', { path = parser })
    end
  end,
})

require('core.opts')
require('plugins')
require('core.autocmds')
require('core.keys')
require('core.lsp')
require('statusline')
