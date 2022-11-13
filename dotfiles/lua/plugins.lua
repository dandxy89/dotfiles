-- [[ plug.lua ]]
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- impatient
    use 'lewis6991/impatient.nvim'

    -- treesitter + treesitter context
    use {
        'nvim-treesitter/nvim-treesitter',
        run = ':TSUpdate'
    }
    use {'nvim-treesitter/nvim-treesitter-context'}

    -- Highlights for files changed in git projects
    use {
        'lewis6991/gitsigns.nvim',
        config = function()
            require('gitsigns').setup()
        end,
        requires = {'nvim-lua/plenary.nvim'}
    }

    -- Telescope
    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}},
        config = function()
            require('telescope').setup {
                extensions = {
                    fzf = {
                        fuzzy = true, -- false will only do exact matching
                        override_generic_sorter = true, -- override the generic sorter
                        override_file_sorter = true, -- override the file sorter
                        case_mode = "smart_case" -- or "ignore_case" or "respect_case"
                    }
                }
            }
            require('telescope').load_extension('fzf')
        end
    }
    use {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make'
    }

    -- Theme
    use {"ellisonleao/gruvbox.nvim"}

    -- Git Diff View
    use {
        'sindrets/diffview.nvim',
        requires = 'nvim-lua/plenary.nvim'
    }

    -- Highlight Arguments
    use {'m-demare/hlargs.nvim'}

    -- Easy Commenting
    use {
        'numToStr/Comment.nvim',
        config = function()
            require("Comment").setup()
        end
    }

    -- Test Runner
    use {'vim-test/vim-test'}

    -- Leap - faster navigation
    use {
        'ggandor/leap.nvim',
        config = function()
            require('leap').add_default_mappings()
        end
    }

    -- Harpoon
    use {'ThePrimeagen/harpoon'}

    -- Rust
    use {'rust-lang/rust.vim'}
    use {'simrat39/rust-tools.nvim'}
    use {'saecki/crates.nvim'}

    -- Undo Tree
    use {'mbbill/undotree'}

    -- LSP
    use {"williamboman/mason.nvim"}
    use {"williamboman/mason-lspconfig.nvim"}
    use {"neovim/nvim-lspconfig"}

    -- LSP Completion
    use {'hrsh7th/nvim-cmp'}
    use {'hrsh7th/cmp-nvim-lua'}
    use {'hrsh7th/cmp-buffer'}
    use {'hrsh7th/cmp-nvim-lsp'}
    use {'hrsh7th/cmp-nvim-lsp-signature-help'}
    use {'hrsh7th/cmp-path'}
    use {'hrsh7th/cmp-vsnip'}

    -- Snippets
    use {'L3MON4D3/LuaSnip'}
    use {'rafamadriz/friendly-snippets'}
    use {'saadparwaiz1/cmp_luasnip'}

    -- Noice
    use {
        "folke/noice.nvim",
        event = "VimEnter",
        config = function()
            require("noice").setup()
            require("telescope").load_extension("noice")
        end,
        requires = {"MunifTanjim/nui.nvim", "rcarriga/nvim-notify"}
    }

    -- Autopairs
    use {
        "windwp/nvim-autopairs",
        config = function()
            require("nvim-autopairs").setup {}
        end
    }

    -- http://neovimcraft.com/plugin/nvim-neo-tree/neo-tree.nvim/index.html
    use {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v2.x",
        requires = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim", {
            's1n7ax/nvim-window-picker',
            tag = "v1.*"
        }}
    }
end)
