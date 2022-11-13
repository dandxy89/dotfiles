-- [[ init.lua ]]
-- brew reinstall neovim
--
require('impatient')

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.loaded_matchparen = 1
vim.g.loaded_matchit = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_gzip = 1
vim.g.loaded_zipPlugin = 1
vim.g.loaded_2html_plugin = 1
vim.g.loaded_shada_plugin = 1
vim.g.loaded_spellfile_plugin = 1
vim.g.loaded_tutor_mode_plugin = 1
vim.g.loaded_remote_plugins = 1

-- Settings
require('opts')
require('keys')

-- Pack Installs
require('plugins')

-- LSP Setup
require('lsp_config')

-- Init Plugins
require("luasnip.loaders.from_vscode").lazy_load()
require('nvim_neo_tree')
require('window_picker')
