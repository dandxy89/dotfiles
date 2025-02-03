---@diagnostic disable: no-unknown
return {
    {
        -- "miikanissi/modus-themes.nvim",
        "deparr/tairiki.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme('modus')
            require('tairiki').load()
        end,
    },
    {
        "williamboman/mason.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
            require("mason").setup({ PATH = "prepend" })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        event = "LspAttach",
        lazy = true,
        config = function()
            require("mason-lspconfig").setup({
                ensure_installed = {
                    "lua_ls",
                    "rust_analyzer",
                    "basedpyright",
                    "marksman",
                    "harper_ls",
                    "taplo",
                },
            })
        end,
    },
    {
        "artemave/workspace-diagnostics.nvim",
        event = "LspAttach",
        lazy = true,
    },
    {
        "MysticalDevil/inlay-hints.nvim",
        lazy = true,
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = function()
            require("inlay-hints").setup({})
        end,
    },
    {
        'vxpm/ferris.nvim',
        ft = "rust",
        lazy = true,
    },
    {
        "neovim/nvim-lspconfig",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = { "saghen/blink.cmp" },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local lspconfig = require("lspconfig")

            lspconfig.zls.setup({
                capabilities = capabilities,
                cmd = { "zls" },
            })
            lspconfig.lua_ls.setup({
                capabilities = capabilities,
            })
            lspconfig.ts_ls.setup({
                capabilities = capabilities,
                filetypes = {
                    "javascript",
                    "javascriptreact",
                    "typescript",
                    "typescriptreact",
                    "html",
                },
            })
            lspconfig.basedpyright.setup({
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        typeCheckingMode = "standard",
                    },
                },
            })
            -- Install with: pip install "ruff-lsp"
            lspconfig.ruff.setup({
                capabilities = capabilities,
                settings = {
                    organizeImports = false,
                },
            })
            lspconfig.pest_ls.setup({
                capabilities = capabilities,
                settings = {
                    organizeImports = false,
                },
            })
            lspconfig.rust_analyzer.setup({
                capabilities = capabilities,
                settings = {
                    ["rust-analyzer"] = {
                        cargo = {
                            features = "all",
                            buildScripts = {
                                enable = true,
                            },
                        },
                        checkOnSave = {
                            command = "check",
                        },
                        diagnostics = {
                            enable = true,
                        },
                        inlayHints = {
                            enable = true,
                            locationLinks = false,
                            parameter_hints_prefix = "  <-  ",
                            other_hints_prefix = "  =>  ",
                            highlight = "LspCodeLens",
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true,
                            },
                        },
                        lens = {
                            enable = true,
                            methodReferences = true,
                            references = true,
                            implementations = false,
                        },
                        interpret = {
                            tests = true,
                        },
                        rustfmt = {
                            overrideCommand = "cargo +nightly fmt",
                        },
                        procMacro = {
                            enable = true,
                        },
                    },
                },
            })
            lspconfig.marksman.setup({ capabilities = capabilities })
            lspconfig.taplo.setup({ capabilities = capabilities })
            lspconfig.harper_ls.setup({
                capabilities = capabilities,
                settings = {
                    ["harper-ls"] = {
                        userDictPath = "~/dict.txt",
                        spell_check = true,
                        spelled_numbers = false,
                        an_a = true,
                        sentence_capitalization = true,
                        unclosed_quotes = true,
                        wrong_quotes = false,
                        long_sentences = true,
                        repeated_words = true,
                        spaces = true,
                        matcher = true,
                        correct_number_suffix = true,
                        number_suffix_capitalization = true,
                        multiple_sequential_pronouns = true,
                    },
                },
            })
        end,
    },
}
