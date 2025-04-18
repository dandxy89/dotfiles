return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = "BufReadPre",
        opts = function()
            local gitIcons = {
                LineAdded = " ",
                LineModified = " ",
                LineRemoved = " "
            }
            require("gitsigns").setup({
                signs = {
                    add = {text = gitIcons.LineAdded},
                    change = {text = gitIcons.LineModified},
                    delete = {text = gitIcons.LineRemoved}
                },
                signcolumn = true,
                linehl = false,
                numhl = false,
                word_diff = false,
                sign_priority = 9,
                watch_gitdir = {interval = 1000},
                attach_to_untracked = false
            })
        end
    }
}
