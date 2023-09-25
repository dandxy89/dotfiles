-- [[ Disable builtin plugins ]]
require "core.bootstrap"

local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- -- [[ Lazy Plugins ]]
require("lazy").setup {
    spec = {
        { import = "plugins" },
    },
    defaults = { lazy = true },
    checker = { enabled = false },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                "2html_plugin",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "netrw",
                "netrwPlugin",
                "netrwSettings",
                "netrwFileHandlers",
                "matchit",
                "tar",
                "tarPlugin",
                "rrhelper",
                "spellfile_plugin",
                "vimball",
                "vimballPlugin",
                "zip",
                "zipPlugin",
                "tutor",
                "rplugin",
                "syntax",
                "synmenu",
                "optwin",
                "compiler",
                "bugreport",
                "ftplugin",
            },
        },
    },
}

require "core.keys"
require "core.opts"
require "core.autocmds"
require "core.filetype"
