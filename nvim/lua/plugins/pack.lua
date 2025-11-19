-- Plugin management system
local path_util = require("util.path")

vim.fn.mkdir(path_util.start_path, "p")
vim.fn.mkdir(path_util.opt_path, "p")

local plugins = {
    -- (always loaded)
    -- { url = "https://github.com/deparr/tairiki.nvim",                         name = "tairiki.nvim",                opt = false },
    { url = "https://github.com/dapovich/anysphere.nvim",                     name = "anysphere.nvim",              opt = false },
    { url = "https://github.com/nvim-lua/plenary.nvim",                       name = "plenary.nvim",                opt = false },
    { url = "https://github.com/MunifTanjim/nui.nvim",                        name = "nui.nvim",                    opt = false },
    { url = "https://github.com/folke/snacks.nvim",                           name = "snacks.nvim",                 opt = false },
    { url = "https://github.com/nvim-lualine/lualine.nvim",                   name = "lualine.nvim",                opt = false },
    { url = "https://github.com/ggandor/leap.nvim",                           name = "leap.nvim",                   opt = false },
    { url = "https://github.com/nvim-treesitter/nvim-treesitter",             name = "nvim-treesitter",             opt = false },
    { url = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", name = "nvim-treesitter-textobjects", opt = false },
    { url = "https://github.com/williamboman/mason.nvim",                     name = "mason.nvim",                  opt = false },
    { url = "https://github.com/ibhagwan/fzf-lua",                            name = "fzf-lua",                     opt = false },
    -- (lazy)
    { url = "https://github.com/nvim-tree/nvim-web-devicons",                 name = "nvim-web-devicons",           opt = true, trigger = "file" },
    -- { url = "https://github.com/neovim/nvim-lspconfig",                       name = "nvim-lspconfig",              opt = true, trigger = "file" },
    { url = "https://github.com/williamboman/mason-lspconfig.nvim",           name = "mason-lspconfig.nvim",        opt = true, trigger = "file" },
    { url = "https://github.com/chrisgrieser/nvim-lsp-endhints",              name = "nvim-lsp-endhints",           opt = true, trigger = "lsp" },
    -- { url = "https://github.com/code-biscuits/nvim-biscuits",                 name = "nvim-biscuits",               opt = true, trigger = "file" },
    { url = "https://github.com/saghen/blink.cmp",                            name = "blink.cmp",                   opt = true, trigger = "insert",       build = "cargo build --release" },
    { url = "https://github.com/saghen/blink.pairs",                          name = "blink.pairs",                 opt = true, trigger = "insert",       build = "cargo build --release" },
    { url = "https://github.com/saghen/blink.indent",                         name = "blink.indent",                opt = true, trigger = "file" },
    { url = "https://github.com/mikavilpas/blink-ripgrep.nvim",               name = "blink-ripgrep.nvim",          opt = true, trigger = "insert" },
    { url = "https://github.com/ribru17/blink-cmp-spell",                     name = "blink-cmp-spell",             opt = true, trigger = "insert" },
    { url = "https://github.com/lewis6991/gitsigns.nvim",                     name = "gitsigns.nvim",               opt = true, trigger = "file" },
    { url = "https://github.com/nvim-pack/nvim-spectre",                      name = "nvim-spectre",                opt = true, trigger = "command" },
    { url = "https://github.com/christoomey/vim-tmux-navigator",              name = "vim-tmux-navigator",          opt = true, trigger = "keymap" },
    { url = "https://github.com/vim-test/vim-test",                           name = "vim-test",                    opt = true, trigger = "command" },
    { url = "https://github.com/preservim/vimux",                             name = "vimux",                       opt = true, trigger = "command" },
    { url = "https://github.com/vxpm/ferris.nvim",                            name = "ferris.nvim",                 opt = true, trigger = "filetype:rust" },
    { url = "https://github.com/Saecki/crates.nvim",                          name = "crates.nvim",                 opt = true, trigger = "cargo-toml" },
}

-- Load manager modules
local install = require("plugins.manager.install")
local update = require("plugins.manager.update")
local status = require("plugins.manager.status")
local lazy = require("plugins.manager.lazy")

-- Install missing plugins on startup
install.ensure_plugins_startup(plugins)

-- Setup commands
install.setup_command(plugins)
update.setup_command(plugins)
status.setup_commands(plugins)

-- Setup lazy loading
lazy.setup_lazy_loading(plugins)

return {
    plugins = plugins,
    setup_lazy_loading = function() lazy.setup_lazy_loading(plugins) end,
}
