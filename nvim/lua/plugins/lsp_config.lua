return {
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            { "williamboman/mason.nvim" },
            { "williamboman/mason-lspconfig.nvim" },
            { "chrisgrieser/nvim-lsp-endhints", event = "LspAttach", opts = {} },
            {
                "pest-parser/pest.vim",
                event = "LspAttach",
                ft = "pest",
                lazy = true,
                enabled = false,
            },
            { "vxpm/ferris.nvim" },
            {
                "saghen/blink.cmp",
                lazy = true,
                event = "LspAttach",
                version = "1.*",
                dependencies = {
                    { "mikavilpas/blink-ripgrep.nvim" },
                    { "ribru17/blink-cmp-spell" },
                    { "giuxtaposition/blink-cmp-copilot", enabled = true },
                },
                opts = {
                    appearance = { use_nvim_cmp_as_default = true },
                    completion = {
                        keyword = { range = "prefix" },
                        ghost_text = { enabled = true },
                        list = {
                            selection = { preselect = false, auto_insert = true },
                        },
                        menu = {
                            auto_show = true,
                            border = "rounded",
                            draw = { treesitter = { "lsp" } },
                        },
                        documentation = {
                            auto_show = true,
                            window = { border = "rounded" },
                            treesitter_highlighting = true,
                            auto_show_delay_ms = 200,
                        },
                        trigger = { show_on_insert_on_trigger_character = true },
                    },
                    fuzzy = { implementation = "rust" },
                    keymap = { preset = "enter" },
                    signature = { enabled = true, window = { border = "rounded" } },
                    sources = {
                        default = {
                            "lsp",
                            "path",
                            "snippets",
                            "cmdline",
                            "buffer",
                            "ripgrep",
                            "spell",
                            "copilot",
                        },
                        providers = {
                            ripgrep = {
                                module = "blink-ripgrep",
                                name = "Ripgrep",
                                min_keyword_length = 1,
                            },
                            lsp = {
                                name = "LSP",
                                module = "blink.cmp.sources.lsp",
                                min_keyword_length = 0,
                            },
                            spell = { name = "Spell", module = "blink-cmp-spell" },
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
        },
        config = function(_, _)
            require("lsp-endhints").setup({})
            vim.lsp.config("*", {
                capabilities = vim.lsp.protocol.make_client_capabilities(),
            })

            local servers = {}
            local lsp_servers_path = vim.fn.stdpath("config") .. "/after/lsp"

            -- Check if LSP config directory exists
            if vim.fn.isdirectory(lsp_servers_path) == 1 then
                for file in vim.fs.dir(lsp_servers_path) do
                    local name = file:match("(.+)%.lua$")
                    if name then
                        servers[name] = true
                    end
                end
            else
                vim.notify("LSP config directory not found: " .. lsp_servers_path, vim.log.levels.WARN)
            end

            require("mason").setup({
                PATH = "prepend",
                -- Using default registry for better stability
            })
            require("mason-lspconfig").setup({
                ensure_installed = vim.tbl_keys(servers),
                automatic_installation = true,
            })

            vim.diagnostic.config({
                signs = {
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
                    },
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.WARN] = "",
                    },
                },
                update_in_insert = true,
                virtual_text = true,
                underline = true,
                severity_sort = true,
            })

            local icons = {
                Class = " ",
                Color = " ",
                Constant = " ",
                Constructor = " ",
                Enum = " ",
                EnumMember = " ",
                Event = " ",
                Field = " ",
                File = " ",
                Folder = " ",
                Function = "󰊕 ",
                Interface = " ",
                Keyword = " ",
                Method = "ƒ ",
                Module = "󰏗 ",
                Property = " ",
                Snippet = " ",
                Struct = " ",
                Text = " ",
                Unit = " ",
                Value = " ",
                Variable = " ",
            }

            local completion_kinds = vim.lsp.protocol.CompletionItemKind
            for i, kind in ipairs(completion_kinds) do
                completion_kinds[i] = icons[kind] and icons[kind] .. kind or kind
            end
        end,
    },
}
