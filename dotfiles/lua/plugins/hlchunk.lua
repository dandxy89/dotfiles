--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Chunky                             ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

---@diagnostic disable: missing-fields
return {
    {
        "shellRaining/hlchunk.nvim",
        keys = { "<leader>u" },
        event = "InsertEnter",
        opts = function()
            require("hlchunk").setup({
                blank = {
                    enable = true,
                    chars = {
                        " ",
                    },
                    style = {
                        { bg = vim.fn.synIDattr(vim.fn.synIDtrans(vim.fn.hlID("cursorline")), "bg", "gui") },
                        { bg = "", fg = "" },
                    },
                },
                indent = {
                    enable = true,
                    chars = {
                        " ",
                    },
                },
                chunk = {
                    style = "#00ffff",
                },
            })
        end,
    },
}
