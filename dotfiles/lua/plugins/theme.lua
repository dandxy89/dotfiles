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
  --   "Mofiqul/vscode.nvim",
  --   priority = 1000,
  --   lazy = false,
  --   config = function()
  --     vim.o.background = "dark"
  --     require("vscode").setup {}
  --   end,
  -- },
  {
    "ayu-theme/ayu-vim",
    priority = 1000,
    lazy = false,
    config = function()
      vim.cmd "colorscheme ayu"
    end,
  },
}
