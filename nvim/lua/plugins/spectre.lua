return {
    {
        "nvim-pack/nvim-spectre",
        lazy = true,
        event = "BufReadPre",
        dependencies = {
            { "nvim-lua/plenary.nvim" },
        },
        opts = function()
            vim.keymap.set("n", "<Leader>S", '<cmd>lua require("spectre").toggle()<CR>', { desc = "Toggle Spectre" })
            vim.keymap.set(
                "n",
                "<Leader>sw",
                '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
                { desc = "Search current word" }
            )
            vim.keymap.set(
                "v",
                "<Leader>sw",
                '<esc><cmd>lua require("spectre").open_visual()<CR>',
                { desc = "Search current word" }
            )
            vim.keymap.set(
                "n",
                "<Leader>sp",
                '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
                { desc = "Search on current file" }
            )
            require("spectre").setup({})
        end,
    },
}
