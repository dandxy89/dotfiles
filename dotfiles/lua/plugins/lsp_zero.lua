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
        event = "InsertEnter",
        opts = function()
            require("core.lsp_zero")
            require("hlargs").setup()
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
            { "hrsh7th/cmp-nvim-lua" }, --
            { "lukas-reineke/cmp-rg" }, -- ripgrep
            { "lukas-reineke/cmp-under-comparator" },
            { "hrsh7th/cmp-nvim-lsp-signature-help" },
            { "ray-x/cmp-treesitter" },
            -- Snippets
            { "L3MON4D3/LuaSnip", dependencies = { "rafamadriz/friendly-snippets" }, run = "make install_jsregexp" },
            -- Highlights
            { "m-demare/hlargs.nvim" }, -- require('hlargs').setup()
            -- Icons
            { "onsails/lspkind.nvim" },
            -- Rust
            { "simrat39/rust-tools.nvim" },
        },
    },
}
