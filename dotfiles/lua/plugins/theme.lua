--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Colour Schemes                     ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    -- {
    --     "gmr458/vscode_dark_modern.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         require("dark_modern").setup({
    --             cursorline = true,
    --             transparent_background = false,
    --             nvim_tree_darker = true,
    --         })
    --         vim.cmd.colorscheme("dark_modern")
    --     end,
    -- },
    {
        "craftzdog/solarized-osaka.nvim",
        lazy = false,
        priority = 1000,
        opts = function()
            return {
                transparent = true,
            }
        end,
        config = function()
            vim.cmd.colorscheme("solarized-osaka")
        end,
    }
}
