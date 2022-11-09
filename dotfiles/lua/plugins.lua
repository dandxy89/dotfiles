-- [[ plug.lua ]]
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    -- Post-install/update hook with neovim command
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use { 'nvim-treesitter/nvim-treesitter-context' }

    -- Use dependency and run lua function after load
    use {
        'lewis6991/gitsigns.nvim',
        requires = { 'nvim-lua/plenary.nvim' },
        config = function()
            require('gitsigns').setup()
        end
    }

    use {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
        requires = {{'nvim-lua/plenary.nvim'}}
    }
    use {'nvim-telescope/telescope-fzf-native.nvim', run = 'make' }

    -- Theme
    use { "ellisonleao/gruvbox.nvim" }

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

    -- Nerd Tree
    use {
      'nvim-tree/nvim-tree.lua', 
      requires = { 'nvim-tree/nvim-web-devicons' }, tag = 'nightly'
    }

    -- Leap - faster navigation
    use {'ggandor/leap.nvim'}

    -- Harpoon
    use {'ThePrimeagen/harpoon'}

    -- Rust
    use {'rust-lang/rust.vim'}
    use {'simrat39/rust-tools.nvim'}
    use {'saecki/crates.nvim'}

    -- Undo Tree
    use {'mbbill/undotree'}

    -- LSP
    use { "williamboman/mason.nvim" }
    use { "williamboman/mason-lspconfig.nvim" }
    use { "neovim/nvim-lspconfig" }

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

end)
