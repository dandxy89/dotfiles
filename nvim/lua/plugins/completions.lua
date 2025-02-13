return {
    -- {
    --     "zbirenbaum/copilot.lua",
    --     lazy = true,
    --     disabled = true,
    --     cmd = "Copilot",
    --     event = "LspAttach",
    --     config = function()
    --         require("copilot").setup({
    --             suggestion = { enabled = false },
    --             panel = { enabled = false }
    --         })
    --     end
    -- },
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
            { "ribru17/blink-cmp-spell" },
            -- { "giuxtaposition/blink-cmp-copilot" }
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
                    max_items = 100,
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
                default = {
                    "lsp", "path", "snippets",
                    "buffer", "ripgrep", "spell",
                    -- "copilot"
                },
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
                    spell = {
                        name = "Spell",
                        module = "blink-cmp-spell"
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
