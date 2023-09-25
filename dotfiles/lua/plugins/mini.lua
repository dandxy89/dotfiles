return {
    {
        "echasnovski/mini.starter",
        lazy = false,
        config = function()
            local starter = require "mini.starter"
            starter.setup {
                items = {
                    starter.sections.telescope(),
                },
                content_hooks = {
                    starter.gen_hook.aligning("center", "center"),
                },
            }
        end,
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup()
        end,
    },
    {
        "echasnovski/mini.cursorword",
        event = "VeryLazy",
        config = function()
            require("mini.cursorword").setup()
        end,
    },
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        config = function()
            require("mini.pairs").setup()
        end,
    },
}
