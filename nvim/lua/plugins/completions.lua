return {
    -- <https://github.com/RRethy/vim-illuminate>
    {
        "saghen/blink.cmp",
        version = '0.7.6',
        lazy = true,
        event = "InsertEnter",
        dependencies = {
            { 'rafamadriz/friendly-snippets' },
            { "mikavilpas/blink-ripgrep.nvim" },
            { "vxpm/ferris.nvim",             ft = "rust" },
            { "pest-parser/pest.vim",         ft = "pest" },
        },
        opts = {
            completion = {
                list = {
                    selection = "preselect"
                },
            },
            keymap = { preset = 'enter' },
            sources = {
                default = { 'lsp', 'path', 'buffer', "ripgrep" },
            },
        },
    },
}
