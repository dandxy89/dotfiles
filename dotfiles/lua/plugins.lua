local ensure_packer = function()
    local fn = vim.fn
    local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
        fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
        vim.cmd [[packadd packer.nvim]]
        return true
    end
    return false
end

local packer_bootstrap = ensure_packer()

return require('packer').startup({
    function(use)
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        -- Impatient
        use 'lewis6991/impatient.nvim'

        -- Treesitter + Treesitter context
        use {
            'nvim-treesitter/nvim-treesitter',
            run = ':TSUpdate',
            requires = {'nvim-treesitter/nvim-treesitter-context'}
        }

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
            branch = 'master',
            requires = {'nvim-lua/plenary.nvim', 'yegappan/mru', 'alan-w-255/telescope-mru.nvim', {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'make'
            }},
            config = function()
                require('telescope').setup {
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
                require'telescope'.load_extension('mru')
            end
        }
        -- Theme
        use 'navarasu/onedark.nvim'

        -- Highlight Arguments
        use 'm-demare/hlargs.nvim'

        -- Easy Commenting
        use {
            'numToStr/Comment.nvim',
            config = function()
                require('Comment').setup()
            end
        }

        -- Test Runner
        use 'vim-test/vim-test'

        -- Leap - faster navigation
        use {
            'ggandor/leap.nvim',
            config = function()
                require('leap').add_default_mappings()
            end
        }

        -- Harpoon
        use 'ThePrimeagen/harpoon'

        -- Rust
        use {'simrat39/rust-tools.nvim'}
        use {
            'saecki/crates.nvim',
            event = {"BufRead Cargo.toml"},
            requires = {{'nvim-lua/plenary.nvim'}},
            config = function()
                require('crates').setup()
            end
        }

        -- Undo Tree
        use {
            'mbbill/undotree',
            event = 'InsertEnter'
        }

        -- LSP
        use 'williamboman/mason.nvim'
        use 'williamboman/mason-lspconfig.nvim'
        use 'neovim/nvim-lspconfig'

        -- LSP Completion
        use {
            'hrsh7th/nvim-cmp',
            requires = {'hrsh7th/cmp-buffer', 'hrsh7th/cmp-nvim-lsp', 'hrsh7th/cmp-nvim-lsp-signature-help',
                        'hrsh7th/cmp-path', 'hrsh7th/cmp-vsnip', 'lukas-reineke/cmp-under-comparator',
                        'lukas-reineke/cmp-rg'}
        }

        -- Noice
        use {
            'folke/noice.nvim',
            event = 'VimEnter',
            config = function()
                require('noice').setup()
                require('telescope').load_extension('noice')
            end,
            requires = {'MunifTanjim/nui.nvim', 'rcarriga/nvim-notify'}
        }

        -- http://neovimcraft.com/plugin/nvim-neo-tree/neo-tree.nvim/index.html
        use {'kyazdani42/nvim-web-devicons'}
        use {
            'nvim-neo-tree/neo-tree.nvim',
            branch = 'v2.x',
            requires = {'nvim-lua/plenary.nvim', 'kyazdani42/nvim-web-devicons', 'MunifTanjim/nui.nvim'}
        }

        -- Autopairs
        use {
            'windwp/nvim-autopairs',
            config = function()
                require('nvim-autopairs').setup {}
            end
        }

        if packer_bootstrap then
            require('packer').sync()
        end
    end,
    config = {
        -- max_jobs = 40,
        auto_reload_compiled = true,
        compile_on_sync = true
    }
})
