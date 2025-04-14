return {
    {
        "lewis6991/gitsigns.nvim",
        lazy = true,
        event = "BufReadPre",
        opts = {
            signs = {
                add = {text = "▎"},
                change = {text = "▎"},
                delete = {text = ""},
                topdelete = {text = ""},
                changedelete = {text = "▎"},
                untracked = {text = "▎"}
            },
            signs_staged = {
                add = {text = "▎"},
                change = {text = "▎"},
                delete = {text = ""},
                topdelete = {text = ""},
                changedelete = {text = "▎"}
            },
        }
    }
}
