--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            init.lua                           ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- [[ Disable builtin plugins ]]
require("core.bootstrap")

local g = vim.g
g.mapleader = " "
g.maplocalleader = " "
g.loaded_ruby_provider = 0
g.loaded_perl_provider = 0

-- netrw
vim.g.netrw_banner = 0    -- gets rid of the annoying banner for netrw
vim.g.netrw_liststyle = 3 -- tree style view in netrw

-- -- [[ Lazy Plugins ]]
require("lazy").setup {
    spec = {
        { import = "plugins" },
    },
    defaults = { 
        lazy = true
    },
    checker = { 
        enabled = false
    },
    install = {
        missing = false,
    },
    performance = {
        cache = {
            enabled = true,
        },
        rtp = {
            disabled_plugins = {
                disabled_plugins = {
                    "2html_plugin",
                    "tohtml",
                    "getscript",
                    "getscriptPlugin",
                    "gzip",
                    "logipat",
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
    },
}

require("core.keys")
require("core.opts")
require("core.autocmds")
require("core.filetype")
