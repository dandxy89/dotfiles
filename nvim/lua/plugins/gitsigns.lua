--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Git                                ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "lewis6991/gitsigns.nvim",
        event = "VeryLazy",
        keys = { "<leader>u" },
        ft = {
            "pest", "rust", "python", "lua", "ocamllsp",
            "dune", "javascript", "typescript",
            "typescriptreact", "typescript.tsx"
        },
        config = function()
            local gitIcons = {
                LineAdded = " ",
                LineModified = " ",
                LineRemoved = " ",
                FileDeleted = " ",
                FileIgnored = "◌",
                FileRenamed = " ",
                FileStaged = "S",
                FileUnmerged = "",
                FileUnstaged = "",
                FileUntracked = "U",
                Diff = " ",
                Repo = " ",
                Octoface = " ",
                Copilot = " ",
                Branch = "",
            }
            require("gitsigns").setup({
                signs               = {
                    add    = { text = gitIcons.LineAdded },
                    change = { text = gitIcons.LineModified },
                    delete = { text = gitIcons.LineRemoved },
                },
                signcolumn          = true,  -- Toggle with `:Gitsigns toggle_signs`
                linehl              = false, -- Toggle with `:Gitsigns toggle_linehl`
                numhl               = false, -- Toggle with `:Gitsigns toggle_nunhl`
                word_diff           = false, -- Toggle with `:Gitsigns toggle_word_diff`
                sign_priority       = 9,
                watch_gitdir        = {
                    interval = 1000,
                },
                attach_to_untracked = false,
            })
        end,
    },
}
