return {
    -- {
    --     "rockyzhang24/arctic.nvim",
    --     branch = "v2",
    --     dependencies = { "rktjmp/lush.nvim" },
    --     config = function()
    --         vim.cmd("colorscheme arctic")
    --     end,
    -- },
    {
        "ricardoraposo/nightwolf.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            vim.opt.background = "dark"
            vim.cmd.colorscheme("nightwolf")
        end,
    },
}
