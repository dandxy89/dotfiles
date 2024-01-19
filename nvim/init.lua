---@diagnostic disable: undefined-global, inject-field
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
g.loaded_node_provider = 0
g.loaded_python3_provider = 0

-- netrw
vim.g.netrw_liststyle = 3 -- tree style view in netrw

-- -- [[ Lazy Plugins ]]
require("lazy").setup {
    change_detection = {
        enabled = false,
        notify = false,
    },
    ui = {
        border = "rounded",
    },
    spec = {
        { import = "plugins" },
    },
    defaults = {
        lazy = true
    },
    checker = {
        enabled = false,
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
                "2html_plugin",
                "tohtml",
                "getscript",
                "getscriptPlugin",
                "gzip",
                "logipat",
                "matchit",
                "matchparen",
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
                "osc52",
            },

        },
    },
}

require("core.keys")
require("core.opts")
require("core.autocmds")
require("core.filetype")
