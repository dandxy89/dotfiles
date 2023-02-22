return {
  {
    "saecki/crates.nvim",
    ft = "toml",
    opts = function()
      require("crates").setup()
    end,
  },
}
