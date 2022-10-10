-- [[ plug.lua ]]

vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  
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

  -- Git Diff View
  use { 'sindrets/diffview.nvim', requires = 'nvim-lua/plenary.nvim' }

  -- Highlight Arguments
  use { 'm-demare/hlargs.nvim' }

  -- Easy Commenting
  use { 
    'numToStr/Comment.nvim', 
    config = function() require("Comment").setup() end 
  }

  -- Test Runner
  use { 'vim-test/vim-test' }

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
  use { 'neovim/nvim-lspconfig' }               -- Collection of configurations for built-in LSP client
  use { 'williamboman/nvim-lsp-installer' }
  use { 'hrsh7th/nvim-cmp' }                    -- Autocompletion plugin
  use { 'j-hui/fidget.nvim'}                    -- Standalone UI for nvim-lsp progress. Eye candy for the impatient.

  -- LSP Completion
  use { 'hrsh7th/cmp-nvim-lua' }
  use { 'hrsh7th/cmp-buffer' }
  use { 'hrsh7th/cmp-nvim-lsp' }                -- LSP source for nvim-cmp
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