--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Lualine                            ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "nvim-lualine/lualine.nvim",
        cond = vim.g.vscode == nil,
        event = { "BufReadPost", "BufNewFile" },
        opts = function()
            local diagnostics = {
                "diagnostics",
                sections = { "error", "warn" },
                colored = true,        -- Displays diagnostics status in color if set to true.
                always_visible = true, -- Show diagnostics even if there are none.
            }
            ---@diagnostic disable-next-line: undefined-field
            require("lualine").setup({
                options = {
                    theme = "auto", -- Can also be "auto" to detect automatically.
                    component_separators = { left = "", right = "" },
                    section_separators = { left = "", right = "" },
                    icons_enabled = true,
                    always_divide_middle = true,
                    refresh = {
                        statusline = 1000,
                    }
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch", "diff" },
                    lualine_c = { "filename", diagnostics },
                    lualine_x = { "encoding", "fileformat", "filetype" },
                    lualine_y = {
                        {
                            require("lazy.status").updates,
                            cond = require("lazy.status").has_updates,
                            color = { fg = "#ff9e64" },
                        },
                    },
                    lualine_z = { "location" },
                },
                extensions = { 'fzf', "lazy" },
            })
        end,
    },
}
