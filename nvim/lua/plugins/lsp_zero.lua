--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            LSP Zero                           ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "VonHeikemen/lsp-zero.nvim",
        branch = "v3.x",
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "toml" },
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
                    -- "zls",           -- ZIG
                },
                automatic_installation = true,
            })
            require("core.lsp_zero")
            require("hlargs").setup({})
        end,
        dependencies = {
            -- Zig
            -- { "ziglang/zig.vim" },
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },                    -- The completion plugin
            { "hrsh7th/cmp-buffer" },                  -- Buffer completions
            { "hrsh7th/cmp-path" },                    -- Path completions
            { "hrsh7th/cmp-nvim-lsp" },                -- LSP completions
            { "hrsh7th/cmp-cmdline" },                 -- Cmd Line
            { "lukas-reineke/cmp-rg" },                -- Rg completions
            { "lukas-reineke/cmp-under-comparator" },  -- Sort completion
            { "hrsh7th/cmp-nvim-lsp-signature-help" }, -- LSP signature
            { "f3fora/cmp-spell" },
            { "m-demare/hlargs.nvim" },                -- Highlight arguments
            { "RRethy/vim-illuminate" },               -- Highlight word under cursor
            { "pest-parser/pest.vim" },                -- Pest Grammar
            { "hrsh7th/cmp-omni" },                    -- Omnifunc
        },
    },
}
