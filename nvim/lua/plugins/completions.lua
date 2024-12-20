return {
    {
        "pest-parser/pest.vim",
        ft = "pest",
        lazy = true,
    },
    {
        "ziglang/zig.vim",
        ft = "zig",
        lazy = true,
    },
    {
        "saghen/blink.cmp",
        version = "0.10.0",
        lazy = true,
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "mikavilpas/blink-ripgrep.nvim" },
            { "Kaiser-Yang/blink-cmp-dictionary" },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                use_nvim_cmp_as_default = false,
            },
            completion = {
                ghost_text = { enabled = false },
                menu = {
                    auto_show = true,
                    border = "rounded",
                },
                documentation = {
                    auto_show = false,
                    auto_show_delay_ms = 1000,
                    window = { border = "rounded" },
                    treesitter_highlighting = false,
                },
                trigger = {
                    prefetch_on_insert = true,
                    show_on_keyword = true,
                },
            },
            keymap = { preset = "enter" },
            signature = { enabled = true, window = { border = "rounded" } },
            sources = {
                min_keyword_length = 0,
                default = { "lsp", "path", "buffer", "snippets", "ripgrep", "dictionary" },
                providers = {
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                    },
                    dictionary = {
                        module = "blink-cmp-dictionary",
                        name = "Dict",
                    },
                    {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                    },
                },
            },
        },
    },
}
