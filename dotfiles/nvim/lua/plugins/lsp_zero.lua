return {
  {
    -- For keymaps see Github page
    "VonHeikemen/lsp-zero.nvim",
    branch = 'v2.x',
    keys = { "<leader>u" },
    event = "InsertEnter",
    opts = function()
      require "core.lsp_zero"
      require("hlargs").setup()
      require("nvim-test").setup {}
    end,
    dependencies = { -- LSP Support
      { "neovim/nvim-lspconfig" },
      { "williamboman/mason.nvim" },
      { "williamboman/mason-lspconfig.nvim" },
      -- Autocompletion
      { "hrsh7th/nvim-cmp" },
      { "hrsh7th/cmp-buffer" },
      { "hrsh7th/cmp-path" },
      { "saadparwaiz1/cmp_luasnip" },
      { "hrsh7th/cmp-nvim-lsp" },
      { "hrsh7th/cmp-nvim-lua" },
      { "lukas-reineke/cmp-rg" },
      { "lukas-reineke/cmp-under-comparator" },
      { "hrsh7th/cmp-nvim-lsp-signature-help" },
      { "ray-x/cmp-treesitter" },
      -- Snippets
      { "hrsh7th/cmp-calc" },
      { "L3MON4D3/LuaSnip" },
      -- { "saadparwaiz1/cmp_luasnip" },
      { "rafamadriz/friendly-snippets" },
      -- Highlights
      { "m-demare/hlargs.nvim" },
      -- Rust
      { "simrat39/rust-tools.nvim" },
      -- Zig
      { "ziglang/zig.vim" },
      -- Test Runner
      { "klen/nvim-test" },
      -- View and search LSP symbols, tags in Vim/NeoVim.
      { "liuchengxu/vista.vim" },
      {
        "ivanjermakov/troublesum.nvim",
        config = function()
            require("troublesum").setup()
        end
      },
    },
  },
}
