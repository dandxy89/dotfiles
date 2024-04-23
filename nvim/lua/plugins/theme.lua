--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Colour Schemes                     ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    -- {
    --     "projekt0n/github-nvim-theme",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         require('github-theme').setup({})
    --         vim.cmd.colorscheme("github_dark_colorblind")
    --     end,
    -- },
    {
        "tiagovla/tokyodark.nvim",
        priority = 1000,
        lazy = false,
        opts = {},
        config = function(_, opts)
            require("tokyodark").setup(opts) -- calling setup is optional
            vim.cmd [[colorscheme tokyodark]]
        end,
    },
}
