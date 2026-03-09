vim.loader.enable()

vim.keymap.set('', '<Space>', '<Nop>', { silent = true })
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require('plugins.pack')

-- Register tree-sitter-lp grammar (local dev) — must run before any .lp file triggers treesitter
vim.filetype.add({ extension = { lp = 'lp' } })
vim.treesitter.language.register('lp', 'lp')
local lp_parser = vim.fn.expand('~/Projects/tree-sitter-lp/parser.so')
if vim.uv.fs_stat(lp_parser) then
  vim.treesitter.language.add('lp', { path = lp_parser })
end

require('core.opts')
require('core.autocmds')
require('core.keys')
