-- [[ plug.lua ]]

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Post-install/update hook with neovim command
  use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }

   -- Use dependency and run lua function after load
  use {
    'lewis6991/gitsigns.nvim', requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('gitsigns').setup() end
  }

  use {
    'nvim-telescope/telescope.nvim', tag = '0.1.0',
    requires = { {'nvim-lua/plenary.nvim'} }
  }

  -- Theme
  use { 'luisiacc/gruvbox-baby', branch = 'main' }

  -- Icons
  use { 'kyazdani42/nvim-web-devicons' }

  -- Highlight Arguments
  use { 'm-demare/hlargs.nvim' }

  -- Easy Commenting
  use { 
    'numToStr/Comment.nvim', 
    config = function() require("Comment").setup() end 
  }

  -- Nerd Tree
  use { 'preservim/nerdtree' }
  
  -- Harpoon
  use { 'ThePrimeagen/harpoon' }

  -- Rust
  use { 'rust-lang/rust.vim' }
  use { 'simrat39/rust-tools.nvim' }
  use { 'saecki/crates.nvim' }

  -- Undo Tree
  use { 'mbbill/undotree' }

  -- LSP
  use { 'neovim/nvim-lspconfig' }
  use { 'williamboman/nvim-lsp-installer' }
  use { 'weilbith/nvim-code-action-menu' }
  use { 'hrsh7th/nvim-cmp' }

  -- LSP Completion
  use { 'hrsh7th/cmp-nvim-lua' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lsp' }
  use { 'hrsh7th/cmp-nvim-lsp-signature-help' }
  use { 'hrsh7th/cmp-path' }
  use { 'hrsh7th/cmp-vsnip' }

  -- Noice
  use {
    "folke/noice.nvim",
    event = "VimEnter",
    config = function()
      require("noice").setup()
      require("telescope").load_extension("noice")
    end,
    requires = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      "rcarriga/nvim-notify",
  }
}

end)
