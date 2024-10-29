return {
    {
        "ggandor/leap.nvim",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("leap").create_default_mappings()
        end,
    },
}
