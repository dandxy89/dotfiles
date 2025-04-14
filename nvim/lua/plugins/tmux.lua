return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft", "TmuxNavigateDown", "TmuxNavigateUp",
            "TmuxNavigateRight", "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList"
        },
        keys = {
            {"<c-h>", "<cmd><C-U>TmuxNavigateLeft<cr>"},
            {"<c-j>", "<cmd><C-U>TmuxNavigateDown<cr>"},
            {"<c-k>", "<cmd><C-U>TmuxNavigateUp<cr>"},
            {"<c-l>", "<cmd><C-U>TmuxNavigateRight<cr>"},
            {"<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>"}
        }
    }, {
        "vim-test/vim-test",
        event = "LspAttach",
        dependencies = {"preservim/vimux"},
        config = function()
            vim.keymap.set("n", "<Leader>t", ":TestNearest<CR>", {})
            vim.keymap.set("n", "<Leader>T", ":TestFile<CR>", {})
            vim.keymap.set("n", "<Leader>a", ":TestSuite<CR>", {})
            vim.keymap.set("n", "<Leader>l", ":TestLast<CR>", {})
            vim.keymap.set("n", "<Leader>g", ":TestVisit<CR>", {})
            vim.cmd("let test#strategy = 'vimux'")
        end
    }
}
