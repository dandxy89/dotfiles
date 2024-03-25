--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Mini Family                        ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "echasnovski/mini.comment",
        version = false,
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "toml" },
        config = function()
            require("mini.comment").setup()
        end,
    },
    {
        "echasnovski/mini.pairs",
        version = false,
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "toml" },
        config = function()
            require("mini.pairs").setup()
        end,
    },
    {
        "echasnovski/mini.surround",
        version = false,
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "toml" },
        config = function()
            require('mini.surround').setup()
        end,
    }
}
