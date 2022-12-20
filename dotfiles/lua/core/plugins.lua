-- Lazyily Loaded Plugins
require("lazy").setup({
    defaults = {
        lazy = true
    },
    checker = {
        enabled = true
    },
    -- Theme
    {
        'nyoom-engineering/oxocarbon.nvim',
        lazy = true
    },
    -- Startup Dashboard
    {
        'echasnovski/mini.starter',
        lazy = false,
        config = function()
            local starter = require('mini.starter')
            starter.setup({
                items = { starter.sections.telescope() },
                content_hooks = { starter.gen_hook.adding_bullet(), starter.gen_hook.aligning('center', 'center') }
            })
        end
    },
    -- Treesitter + Treesitter context
    {
        'nvim-treesitter/nvim-treesitter',
        build = ':TSUpdate',
        event = "InsertEnter",
        lazy = true,
        dependencies = { 'nvim-treesitter/nvim-treesitter-context' },
        init = function()
            require('nvim-treesitter.configs').setup {
                ensure_installed = { "bash", "c", "cmake", "dockerfile", "hcl", "help", "http", "json", "lua", "make",
                    "markdown", "python", "regex", "rust", "scala", "toml", "vim", "yaml" },
                sync_install = false,
                auto_install = false,
                highlight = {
                    enable = true
                },
                ident = {
                    enable = true
                },
                rainbow = {
                    enable = true,
                    extended_mode = true,
                    max_file_lines = nil
                }
            }
            require("treesitter-context").setup()
        end
    },
    -- Telescope
    {
        'nvim-telescope/telescope.nvim',
        branch = 'master',
        event = "BufReadPre",
        dependencies = { 'nvim-lua/plenary.nvim', 'yegappan/mru', 'alan-w-255/telescope-mru.nvim', {
            'nvim-telescope/telescope-fzf-native.nvim',
            build = 'make'
        } },
        config = function()
            require('telescope').setup {
                pickers = {
                    lsp_references = {
                        show_line = false
                    }
                },
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = 'smart_case' -- or 'ignore_case' or 'respect_case'
                    }
                }
            }
            require('telescope').load_extension('fzf')
            require 'telescope'.load_extension('mru')
        end
    },
    -- vim-startuptime  -i None -n -V0
    {
        "dstein64/vim-startuptime",
        cmd = "StartupTime",
        config = function()
            vim.g.startuptime_tries = 10
        end
    },
    -- Easy Commenting
    {
        'numToStr/Comment.nvim',
        event = "InsertEnter",
        lazy = true,
        config = function()
            require('Comment').setup()
        end
    },
    -- Leap - faster navigation
    {
        'ggandor/leap.nvim',
        event = "InsertEnter",
        lazy = true,
        config = function()
            require('leap').add_default_mappings()
        end
    },
    -- deferred-clipboard
    {
        'EtiamNullam/deferred-clipboard.nvim',
        event = "InsertEnter",
        lazy = true,
        config = function()
            require('deferred-clipboard').setup()
        end
    },
    -- Undo Tree
    {
        'mbbill/undotree',
        event = "InsertEnter",
        lazy = true
    },
    -- LSP Zero
    {
        'VonHeikemen/lsp-zero.nvim',
        keys = { "<leader>u" },
        lazy = true,
        config = function()
            require('core.lsp_zero')
            require('hlargs').setup()
            require("autoclose").setup({})
            require('crates').setup()
        end,
        dependencies = { -- LSP Support
            { 'neovim/nvim-lspconfig' }, { 'williamboman/mason.nvim' }, { 'williamboman/mason-lspconfig.nvim' },
            -- Autocompletion
            { 'hrsh7th/nvim-cmp' }, { 'hrsh7th/cmp-buffer' }, { 'hrsh7th/cmp-path' }, { 'saadparwaiz1/cmp_luasnip' },
            { 'hrsh7th/cmp-nvim-lsp' }, { 'hrsh7th/cmp-nvim-lua' }, { 'lukas-reineke/cmp-rg' },
            { 'lukas-reineke/cmp-under-comparator' }, { 'hrsh7th/cmp-nvim-lsp-signature-help' },
            { 'ray-x/cmp-treesitter' },
            -- Snippets
            { 'hrsh7th/cmp-calc' }, { 'L3MON4D3/LuaSnip' }, { 'saadparwaiz1/cmp_luasnip' },
            { 'rafamadriz/friendly-snippets' },
            { 'm-demare/hlargs.nvim' }, -- Highlights
            { 'simrat39/rust-tools.nvim' }, -- Rust
            { 'saecki/crates.nvim' }, -- Rust
            { 'm4xshen/autoclose.nvim' }, -- Autopairs
            {
                'vim-test/vim-test',
                init = function()
                    vim.cmd [[let test#strategy = "neovim"]]
                end
            } -- Test Runner
        }
    },
    -- DEV Icons
    {
        "nvim-tree/nvim-web-devicons",
        config = function()
            require("nvim-web-devicons").setup({
                default = true
            })
        end
    },
    -- NeoTreeNvim - http://neovimcraft.com/plugin/nvim-neo-tree/neo-tree.nvim/index.html
    {
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v2.x',
        lazy = false
    },
    -- Noice
    {
        'folke/noice.nvim',
        lazy = false,
        config = function()
            require("noice").setup({
                lsp = {
                    -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                    override = {
                        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                        ["vim.lsp.util.stylize_markdown"] = true,
                        ["cmp.entry.get_documentation"] = true
                    },
                    hover = {
                        enabled = false
                    },
                    signature = {
                        enabled = false
                    }
                },
                -- you can enable a preset for easier configuration
                presets = {
                    bottom_search = true, -- use a classic bottom cmdline for search
                    command_palette = true, -- position the cmdline and popupmenu together
                    long_message_to_split = true, -- long messages will be sent to a split
                    inc_rename = false, -- enables an input dialog for inc-rename.nvim
                    lsp_doc_border = false -- add a border to hover docs and signature help
                }
            })
            require('telescope').load_extension('noice')
        end,
        dependencies = { 'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify' }
    }
})
