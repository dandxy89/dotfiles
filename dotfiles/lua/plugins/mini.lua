--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Mini Family                        ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "echasnovski/mini.starter",
        version = false,
        lazy = false,
        priority = 1000,
        config = function()
            local starter = require("mini.starter")
            starter.setup({
                items = {
                    starter.sections.telescope(),
                },
                content_hooks = {
                    starter.gen_hook.aligning("center", "center"),
                },
            })
        end,
    },
    {
        "echasnovski/mini.comment",
        version = false,
        event = "VeryLazy",
        config = function()
            require("mini.comment").setup()
        end,
    },
    {
        "echasnovski/mini.pairs",
        event = "VeryLazy",
        version = false,
        config = function()
            require("mini.pairs").setup()
        end,
    },
}
