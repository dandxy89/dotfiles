return {
    {
        "zbirenbaum/copilot.lua",
        lazy = true,
        enabled = false,
        cmd = "Copilot",
        event = "LspAttach",
        config = function()
            require("copilot").setup({
                suggestion = { enabled = false },
                panel = { enabled = false }
            })
        end
    },
    {
        "pest-parser/pest.vim",
        ft = "pest",
        lazy = true,
    },
    {
        "saghen/blink.cmp",
        version = "0.12.3",
        lazy = true,
        dependencies = {
            { "rafamadriz/friendly-snippets" },
            { "mikavilpas/blink-ripgrep.nvim" },
            { "ribru17/blink-cmp-spell" },
            {
                "giuxtaposition/blink-cmp-copilot",
                enabled = false
            }
        },
        opts = {
            appearance = { use_nvim_cmp_as_default = true },
            completion = {
                keyword = { range = 'prefix' },
                ghost_text = { enabled = false },
                list = { selection = { preselect = false, auto_insert = true } },
                menu = { auto_show = true, border = "rounded", draw = { treesitter = { 'lsp' } } },
                documentation = {
                    window = { border = "rounded" },
                    treesitter_highlighting = true, -- Experiment..
                },
                trigger = { show_on_insert_on_trigger_character = true },
            },
            keymap = { preset = "enter" },
            signature = { enabled = true, window = { border = "rounded" } },
            sources = {
                default = {
                    "lsp", "path", "snippets", "omni",
                    "buffer", "ripgrep", "spell",
                    -- "copilot"
                },
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
                        module = "blink-cmp-spell"
                    },
                    omni = {
                        name = 'Omni',
                        module = 'blink.cmp.sources.omni',
                    },
                    -- copilot = {
                    --     name = "copilot",
                    --     module = "blink-cmp-copilot",
                    --     score_offset = 100,
                    --     async = true,
                    -- }
                }
            }
        },
    },
}
