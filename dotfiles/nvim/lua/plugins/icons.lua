return {
  -- DEV Icons
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true,
    opts = function()
      require("nvim-web-devicons").setup {
        default = true,
      }
    end,
  },
}
