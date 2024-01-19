--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            Git                                ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

return {
    {
        "lewis6991/gitsigns.nvim",
        keys = { "<Leader>u" },
        ft = { "pest", "rust", "python", "lua", "ocamllsp", "dune", "toml" },
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
