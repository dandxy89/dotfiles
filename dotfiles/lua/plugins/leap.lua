return {
  {
    "ggandor/leap.nvim",
    event = "VeryLazy",
    opts = function()
      require("leap").add_default_mappings(true)
    end,
  },
}
