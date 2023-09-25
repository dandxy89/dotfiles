return {
    {
        "EtiamNullam/deferred-clipboard.nvim",
        event = "VeryLazy",
        opts = function()
            require("deferred-clipboard").setup { lazy = true }
        end,
    },
}
