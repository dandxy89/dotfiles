return {
    {
        "vxpm/ferris.nvim",
        ft = "rust",
        lazy = true,
    },
    {
        "pest-parser/pest.vim",
        ft = "pest",
        lazy = true
    },
    {
        "saghen/blink.cmp",
        version = "0.*",
        build = "cargo build --release",
        event = { "InsertEnter" },
        lazy = true,
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "mikavilpas/blink-ripgrep.nvim" },
            { "Kaiser-Yang/blink-cmp-dictionary" },
        },
        opts = {
            completion = {
                ghost_text = { enabled = true },
                list = { selection = "preselect" },
                menu = {
                    border = "rounded",
                    winhighlight =
                    "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
                },
                documentation = {
                    auto_show = true,
                    window = { border = "rounded" },
                },
            },
            keymap = { preset = "enter" },
            signature = { enabled = true, window = { border = "rounded" } },
            sources = {
                default = { "lsp", "path", "buffer", "snippets", "ripgrep", "dictionary" },
                providers = {
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                    },
                    dictionary = {
                        module = 'blink-cmp-dictionary',
                        name = 'Dict',
                    },
                },
            },
        },
    },
}
