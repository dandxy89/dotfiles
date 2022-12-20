-- [[ Disable builtin plugins ]]
require('core.bootstrap')

local g = vim.g
local disabled_built_ins = { "2html_plugin", "getscript", "getscriptPlugin", "gzip", "logipat", "netrw", "netrwPlugin",
    "netrwSettings", "netrwFileHandlers", "matchit", "tar", "tarPlugin", "rrhelper",
    "spellfile_plugin", "vimball", "vimballPlugin", "zip", "zipPlugin", "tutor", "rplugin",
    "synmenu", "optwin", "compiler", "bugreport", "ftplugin", "shada_plugin", "fzf",
    "spellfile_plugin", "tutor_mode_plugin", "remote_plugins" }

for _, plugin in pairs(disabled_built_ins) do
    g["loaded_" .. plugin] = 1
end

g.mapleader = " "
g.maplocalleader = " "
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- -- [[ Lazy Plugins ]]
require('core.keys')
require('core.plugins')

-- -- [[ Settings ]]
require('core.opts')
