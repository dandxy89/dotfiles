return {
    {
        "pest-parser/pest.vim",
        ft = "pest",
        lazy = true,
    },
    {
        "saghen/blink.cmp",
        version = "0.11.0",
        lazy = true,
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "mikavilpas/blink-ripgrep.nvim" },
        },
        ---@module 'blink.cmp'
        ---@type blink.cmp.Config
        opts = {
            appearance = {
                use_nvim_cmp_as_default = true,
            },
            completion = {
                keyword = { range = 'prefix' },
                ghost_text = { enabled = false },
                list = {
                    max_items = 10,
                },
                menu = {
                    auto_show = true,
                    border = "rounded",
                },
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = 500,
                    window = { border = "rounded" },
                    treesitter_highlighting = false,
                },
                trigger = {
                    show_on_insert_on_trigger_character = true,
                },
            },
            keymap = { preset = "enter" },
            signature = { enabled = true, window = { border = "rounded" } },
            sources = {
                default = { "lsp", "path", "snippets", "buffer", "ripgrep" },
                min_keyword_length = 0,
                providers = {
                    ripgrep = {
                        module = "blink-ripgrep",
                        name = "Ripgrep",
                        min_keyword_length = 0,
                    },
                    lsp = {
                        name = "LSP",
                        module = "blink.cmp.sources.lsp",
                        min_keyword_length = 0,
                    },
                }
            }
        },
    },
}
