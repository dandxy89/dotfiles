return {
  -- {
  --     'AlexvZyl/nordic.nvim',
  --     priority = 1000,
  --     lazy = false,
  --     config = function()
  --         require('nordic').setup {
  --             telescope = {
  --                 style = 'flat'
  --             }
  --         }
  --         vim.cmd "colorscheme nordic"
  --     end,
  -- },
  -- {
  --   "neanias/everforest-nvim",
  --   version = false,
  --   lazy = false,
  --   priority = 1000,
  --   config = function()
  --       require("everforest").setup({
  --           background = "hard",
  --       })
  --       require("everforest").load()
  --   end,
  -- },
  -- {
  --     "catppuccin/nvim",
  --     name = "catppuccin",
  --     priority = 1000,
  --     lazy = false,
  --     config = function()
  --       vim.cmd "colorscheme catppuccin-mocha"
  --     end,
  -- },
  -- {
  --     "bluz71/vim-moonfly-colors",
  --     name = "moonfly",
  --     priority = 1000,
  --     lazy = false,
  --     config = function()
  --         vim.cmd [[colorscheme moonfly]]
  --     end,
  -- },
  {
      "gmr458/vscode_dark_modern.nvim",
      name = "dark_modern",
      priority = 1000,
      lazy = false,
      config = function()
          vim.cmd [[colorscheme vscode_dark_modern]]
      end,
  },
  -- {
  --   "tomasiser/vim-code-dark",
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     vim.o.background = "dark"
  --     vim.cmd "colorsche codedark"
  --     -- require("vscode").setup {}
  --   end,
  -- },
  -- {
  --  "ayu-theme/ayu-vim",
  --  priority = 1000,
  --  lazy = false,
  --  config = function()
  --    vim.cmd "colorscheme ayu"
  --  end,
  -- },
  -- {
  --   "projekt0n/github-nvim-theme",
  --   priorty = 1000,
  --   lazy = false,
  --   config = function()
  --       require('github-theme').setup({})
  --       vim.cmd('colorscheme github_dark')
  --   end
  -- },
  -- {
  --     "nyoom-engineering/oxocarbon.nvim",
  --     priorty = 1000,
  --     lazy = false,
  --     config = function()
  --         vim.cmd.colorscheme "oxocarbon"
  --     end,
  -- }
}
