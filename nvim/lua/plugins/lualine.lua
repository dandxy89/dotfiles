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
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "meuter/lualine-so-fancy.nvim",
        },
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
                    globalstatus = true,
                    always_divide_middle = true,
                    refresh = {
                        statusline = 1000,
                    }
                },
                sections = {
                    lualine_a = {
                        { "fancy_mode", width = 3 }
                    },
                    lualine_b = {
                        { "fancy_branch" },
                        { "fancy_diff" },
                    },
                    lualine_c = {
                        { "fancy_cwd", substitute_home = true }
                    },
                    lualine_x = {
                        { "encoding", "fileformat", "filetype" },
                        { "fancy_macro" },
                        { "fancy_diagnostics" },
                        { "fancy_searchcount" },
                        { "fancy_location" },
                    },
                    lualine_y = {
                        {
                            "location"
                        }
                    },
                    lualine_z = {
                        { "fancy_lsp_servers" }
                    },
                },
                extensions = { 'fzf', "lazy" },
            })
        end,
    },
}
