return {
    {
        "kdheepak/lazygit.nvim",
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true }
        },
    },
}
