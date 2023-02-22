return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v2.x",
    keys = {
      { "<leader>n", "<cmd>Neotree toggle<cr>", "neo-tree" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      filesystem = {
        follow_current_file = true,
        hijack_netrw_behavior = "open_current",
      },
      source_selector = {
        winbar = false,
        statusline = false,
      },
    },
  },
}
