return {
    {
        "dnlhc/glance.nvim",
        lazy = true,
        event = "InsertEnter",
        opts = function()
            require("glance").setup({ height = 23 })
        end,
    },
}
