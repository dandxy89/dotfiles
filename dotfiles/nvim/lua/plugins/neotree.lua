return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    -- branch = "v2.x",
    keys = {
      { "<leader>n", "<cmd>Neotree toggle<cr>", "neo-tree" },
    },
    init = function()
      vim.g.neo_tree_remove_legacy_commands = 1
    end,
    opts = {
      auto_clean_after_session_restore = true,
      close_if_last_window = true,
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
