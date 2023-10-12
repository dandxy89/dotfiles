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
        "shortcuts/no-neck-pain.nvim",
        version = "*",
        event = "VeryLazy",
        config = function()
            require("no-neck-pain").setup({
                width = 200,
            })
        end,
    },
    {
        "bluz71/vim-moonfly-colors",
        name = "moonfly",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd.colorscheme("moonfly")
        end,
    },
    -- {
    --     "baliestri/aura-theme",
    --     lazy = false,
    --     priority = 1000,
    --     config = function(plugin)
    --       vim.opt.rtp:append(plugin.dir .. "/packages/neovim")
    --       vim.cmd([[colorscheme aura-dark]])
    --     end
    -- }
    -- {
    --     "nyoom-engineering/oxocarbon.nvim",
    --     priority = 1000,
    --     lazy = false,
    --     config = function()
    --         vim.opt.background = "dark" -- set this to dark or light
    --         vim.cmd.colorscheme("oxocarbon")
    --     end,
    -- },
}
