--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            LSP Zero                           ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        -- For keymaps see Github page
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        keys = { "<leader>u" },
        ft = {
            "pest", "rust", "python", "lua", "ocamllsp",
            "dune", "javascript", "typescript",
            "typescriptreact", "typescript.tsx"
        },
        opts = function()
            require("mason").setup({
                ui = {
                    border = "none",
                    icons = {
                        package_installed = "◍",
                        package_pending = "◍",
                        package_uninstalled = "◍",
                    },
                },
                log_level = vim.log.levels.INFO,
                max_concurrent_installers = 4,
            })
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "tsserver",      -- TYPESCRIPT
                    "yamlls",        -- YAML
                    "dockerls",      -- DOCKER
                    "lua_ls",        -- LUA
                    "pylsp",         -- PYTHON
                    "ruff_lsp",      -- PYTHON
                    "rust_analyzer", -- RUST
                    "pest_ls",       -- PEST
                },
                automatic_installation = true,
            })
            require("core.lsp_zero")
            require("hlargs").setup({})
        end,
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },                    -- The completion plugin
            { "hrsh7th/cmp-buffer" },                  -- Buffer completions
            { "hrsh7th/cmp-path" },                    -- Path completions
            { "hrsh7th/cmp-nvim-lsp" },                -- LSP completions
            { "lukas-reineke/cmp-rg" },                -- Rg completions
            { "lukas-reineke/cmp-under-comparator" },  -- Sort completion
            { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- LSP signature
            -- Snippets
            -- {
            --     "L3MON4D3/LuaSnip",
            --     version = "v2.*",
            --     dependencies = { "rafamadriz/friendly-snippets" },
            --     run = "make install_jsregexp"
            -- },
            -- Highlights
            { "m-demare/hlargs.nvim" },  -- Highlight arguments
            {
                "RRethy/vim-illuminate", -- Highlight word under cursor
            },
            -- Pest Grammar
            { "pest-parser/pest.vim" },
            -- Testing
            -- {
            --     "google/executor.nvim", --  Run test or a given command in the background
            --     config = function()
            --         require("executor").setup({
            --             use_split = true,
            --         })
            --     end
            -- },
            -- Neotest
            -- {
            --     "nvim-neotest/neotest",
            --     dependencies = {
            --         "nvim-lua/plenary.nvim",
            --         "antoinemadec/FixCursorHold.nvim", -- Required to fix lsp doc highlight
            --         "rouge8/neotest-rust",             -- Rust nextest
            --         "nvim-neotest/neotest-python",     -- Python
            --     }
            -- }
        },
    },
}
