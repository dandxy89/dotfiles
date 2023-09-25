return {
    {
        "dnlhc/glance.nvim",
        keys = { "<leader>u" },
        event = "InsertEnter",
        config = function()
            require('glance').setup({
                -- your configuration
            })
        end,
    },
}
