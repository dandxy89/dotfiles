-- [[ init.lua ]]
-- brew reinstall neovim
require('impatient')

vim.cmd([[
  syntax off
  filetype off
]])

-- -- [[ Disable builtin plugins ]]
local g = vim.g
local disabled_built_ins = {"2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", 
                            "netrw", "netrwPlugin", "netrwSettings", "netrwFileHandlers", 
                            "matchit", "tar", "tarPlugin", "rrhelper",
                            "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
                            "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "shada_plugin",
                            "spellfile_plugin", "tutor_mode_plugin", "remote_plugins"}

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

vim.g.loaded_ruby_provider = 0
vim.g.loaded_perl_provider = 0

-- -- [[ Settings ]]
require('opts')
require('keys')

-- -- [[ Pack Installs ]]
require('plugins')

-- -- [[ LSP Setup ]]
require('lsp_config')

-- -- [[ Plugins ]]
require('nvim_neo_tree')

-- syntax on
vim.cmd([[filetype on]])
