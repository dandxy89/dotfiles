return {
    {
        "echasnovski/mini.comment",
        version = false,
        event = "InsertEnter",
        opts = function()
            require("mini.comment").setup({})
        end,
    },
}
