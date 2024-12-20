---@diagnostic disable: no-unknown
return {
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
                    "pyright",
                    "marksman",
                    "harper_ls",
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
        dependencies = { "j-hui/fidget.nvim", "saghen/blink.cmp" },
        config = function()
            require("fidget").setup({})

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
            lspconfig.harper_ls.setup({
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

            -- Custom Diagnostic Icons
            local signs = { Error = "󰅚 ", Warn = "󰳦 ", Hint = "󱡄 ", Info = " " }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
            end

            local lsp = vim.lsp
            lsp.handlers["textDocument/publishDiagnostics"] = lsp.with(lsp.diagnostic.on_publish_diagnostics, {
                virtual_text = true,
                signs = true,
                underline = true,
                update_on_insert = false,
            })
        end,
    },
}
