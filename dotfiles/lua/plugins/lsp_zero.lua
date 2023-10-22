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
        ft = { "pest", "rust", "python", "lua" },
        opts = function()
            require("core.lsp_zero")
            require("hlargs").setup({})
        end,
        dependencies = {
            -- LSP Support
            { "neovim/nvim-lspconfig" },
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            -- Autocompletion
            { "hrsh7th/nvim-cmp" },
            { "hrsh7th/cmp-buffer" },
            { "hrsh7th/cmp-path" },
            { "hrsh7th/cmp-nvim-lsp" }, -- nvim_lsp
            { "lukas-reineke/cmp-rg" }, -- ripgrep
            { "lukas-reineke/cmp-under-comparator" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            -- Snippets
            {
                "L3MON4D3/LuaSnip",
                version = "v2.*",
                dependencies = { "rafamadriz/friendly-snippets" },
                run = "make install_jsregexp"
            },
            -- Highlights
            { "m-demare/hlargs.nvim" },
            -- Icons
            { "onsails/lspkind.nvim" },
            -- Pest Grammar
            { "pest-parser/pest.vim" },
            -- Run test or a given command in the background
            {
                "google/executor.nvim",
                config = function()
                    require("executor").setup({
                        use_split = true,
                    })
                end
            },
        },
    },
}
