return {
    {
        "christoomey/vim-tmux-navigator",
        cmd = {
            "TmuxNavigateLeft",
            "TmuxNavigateDown",
            "TmuxNavigateUp",
            "TmuxNavigateRight",
            "TmuxNavigatePrevious",
            "TmuxNavigatorProcessList",
        },
        keys = {
            { "<c-h>",  "<cmd><C-U>TmuxNavigateLeft<cr>" },
            { "<c-j>",  "<cmd><C-U>TmuxNavigateDown<cr>" },
            { "<c-k>",  "<cmd><C-U>TmuxNavigateUp<cr>" },
            { "<c-l>",  "<cmd><C-U>TmuxNavigateRight<cr>" },
            { "<c-\\>", "<cmd><C-U>TmuxNavigatePrevious<cr>" },
        },
    },
    {
        "vim-test/vim-test",
        dependencies = {
            "preservim/vimux"
        },
        config = function()
            vim.keymap.set("n", "<leader>t", ":TestNearest<CR>", {})
            vim.keymap.set("n", "<leader>T", ":TestFile<CR>", {})
            vim.keymap.set("n", "<leader>a", ":TestSuite<CR>", {})
            vim.keymap.set("n", "<leader>l", ":TestLast<CR>", {})
            vim.keymap.set("n", "<leader>g", ":TestVisit<CR>", {})
            vim.cmd("let test#strategy = 'vimux'")
        end,
    }
}
