-- [[ init.lua ]]
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

-- Load Custom Config
require('vars')
require('opts')
require('keys')
require('plugins')
require('lsp_config')

-- Init Plugins
require('leap').add_default_mappings()
require("nvim-tree").setup({
    renderer = {
        icons = {
            show = {
                file = false,
                folder = false,
                folder_arrow = false,
                git = true
            }
        }
    }
})
require("luasnip.loaders.from_vscode").lazy_load()
