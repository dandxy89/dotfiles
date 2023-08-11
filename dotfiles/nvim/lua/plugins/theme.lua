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
  --   "folke/twilight.nvim",
  --   lazy = true,
  --   keys = { "<leader>u" },
  -- }
  -- {
  --     "nyoom-engineering/oxocarbon.nvim",
  --     priorty = 1000,
  --     lazy = false,
  --     config = function()
  --         vim.cmd.colorscheme "oxocarbon"
  --     end,
  -- }
}
