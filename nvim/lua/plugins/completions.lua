return {
    {
        "pest-parser/pest.vim",
        ft = "pest",
        lazy = true,
        enabled = false,
    },
    {
        "saghen/blink.cmp",
        version = "1.0.0",
        lazy = true,
        dependencies = {
            { "mikavilpas/blink-ripgrep.nvim" },
            { "ribru17/blink-cmp-spell" },
            { "giuxtaposition/blink-cmp-copilot", enabled = true },
            {
                "saghen/blink.pairs",
                version = "*",
                dependencies = { "saghen/blink.download" },
                opts = {
                    mappings = { enabled = true, pairs = {} },
                    highlights = {
                        enabled = true,
                        groups = { "BlinkPairsOrange", "BlinkPairsPurple", "BlinkPairsBlue" },
                    },
                    debug = false,
                },
            },
        },
        opts = {
            appearance = { use_nvim_cmp_as_default = true },
            completion = {
                keyword = { range = "prefix" },
                ghost_text = { enabled = true },
                list = { selection = { preselect = false, auto_insert = true } },
                menu = { auto_show = true, border = "rounded", draw = { treesitter = { "lsp" } } },
                documentation = { window = { border = "rounded" }, treesitter_highlighting = true },
                trigger = { show_on_insert_on_trigger_character = true },
            },
            fuzzy = { implementation = "rust" },
            keymap = { preset = "enter" },
            signature = { enabled = true, window = { border = "rounded" } },
            sources = {
                default = { "lsp", "path", "snippets", "cmdline", "buffer", "ripgrep", "spell", "copilot" },
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
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell",
                    },
                    omni = {
                        name = "Omni",
                        module = "blink.cmp.sources.complete_func",
                    },
                    copilot = {
                        name = "copilot",
                        module = "blink-cmp-copilot",
                        score_offset = 100,
                        async = true,
                    },
                },
            },
        },
    },
}
