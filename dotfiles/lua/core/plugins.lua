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

        -- Telescope
        use {
            'nvim-telescope/telescope.nvim',
            branch = 'master',
            requires = {'nvim-lua/plenary.nvim', 'yegappan/mru', 'alan-w-255/telescope-mru.nvim', {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build'
            }},
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
                require'telescope'.load_extension('mru')
                -- require("telescope").load_extension("harpoon")
            end
        }

        -- Theme
        use 'nyoom-engineering/oxocarbon.nvim'

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

        -- Rust
        use {'simrat39/inlay-hints.nvim'}
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

        -- LSP Zero
        use {
            'VonHeikemen/lsp-zero.nvim',
            requires = { -- LSP Support
            {'neovim/nvim-lspconfig'}, {'williamboman/mason.nvim'}, {'williamboman/mason-lspconfig.nvim'},

            -- Autocompletion
            {'hrsh7th/nvim-cmp'}, {'hrsh7th/cmp-buffer'}, {'hrsh7th/cmp-path'}, {'saadparwaiz1/cmp_luasnip'},
            {'hrsh7th/cmp-nvim-lsp'}, {'hrsh7th/cmp-nvim-lua'}, {'lukas-reineke/cmp-rg'},
            {'lukas-reineke/cmp-under-comparator'}, {'hrsh7th/cmp-nvim-lsp-signature-help'}, -- Snippets
            {'ray-x/cmp-treesitter'}, {'hrsh7th/cmp-calc'}, {'L3MON4D3/LuaSnip'}, {'saadparwaiz1/cmp_luasnip'},
            {'rafamadriz/friendly-snippets'}}
        }

        -- Noice
        use {
            'folke/noice.nvim',
            event = 'VimEnter',
            config = function()
                require("noice").setup({
                    lsp = {
                        -- override markdown rendering so that **cmp** and other plugins use **Treesitter**
                        override = {
                            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                            ["vim.lsp.util.stylize_markdown"] = true,
                            ["cmp.entry.get_documentation"] = true
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
        auto_reload_compiled = true,
        compile_on_sync = true
    }
})
