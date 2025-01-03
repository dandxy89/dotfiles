return {
    {
        "williamboman/mason.nvim",
        lazy = true,
        event = "VeryLazy",
        config = function()
            require("mason").setup({
                PATH = "prepend",
            })
        end,
    },
    {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        event = "VeryLazy",
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
        lazy = true,
    },
    {
        "MysticalDevil/inlay-hints.nvim",
        lazy = true,
        event = "LspAttach",
        dependencies = { "neovim/nvim-lspconfig" },
        opts = function()
            require("inlay-hints").setup({})
        end
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "VeryLazy", "BufReadPre", "BufNewFile" },
        dependencies = { "j-hui/fidget.nvim" },
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
            lspconfig.eslint.setup({
                capabilities = capabilities,
            })
            lspconfig.gopls.setup({
                capabilities = capabilities,
            })
            lspconfig.clangd.setup({
                cmd = {
                    "clangd",
                    "--background-index",
                    "--pch-storage=memory",
                    "--all-scopes-completion",
                    "--pretty",
                    "--header-insertion=never",
                    "-j=4",
                    "--inlay-hints",
                    "--header-insertion-decorators",
                    "--function-arg-placeholders",
                    "--completion-style=detailed",
                },
                filetypes = { "c", "cpp", "objc", "objcpp" },
                root_dir = require("lspconfig").util.root_pattern("src"),
                init_option = { fallbackFlags = { "-std=c++2a" } },
                capabilities = capabilities,
            })
            lspconfig.basedpyright.setup({
                capabilities = capabilities,
                settings = {
                    basedpyright = {
                        typeCheckingMode = "standard",
                    },
                },
            })
            -- Language Server: 'npm install -g pyright'
            lspconfig.pyright.setup({
                capabilities = capabilities,
                settings = {
                    pyright = {
                        -- Use ruff instead
                        disableOrganizeImports = true,
                        pythonPath = vim.fn.exepath("python3"),
                    },
                    -- Use ruff only for linting, just use pyright for LSP feat
                    python = {
                        analysis = {
                            ignore = { "*" },
                        },
                    },
                    telemetry = {
                        enable = false,
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
                        assist = {
                            importEnforceGranularity = true,
                            importPrefix = "crate",
                            emitMustUse = true,
                        },
                        checkOnSave = {
                            command = "check",
                        },
                        diagnostics = {
                            enable = false,
                        },
                        inlayHints = {
                            enable = false,
                            locationLinks = false,
                            parameter_hints_prefix = "  <-  ",
                            other_hints_prefix = "  =>  ",
                            highlight = "LspCodeLens",
                            lifetimeElisionHints = {
                                enable = false,
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
            lspconfig.marksman.setup({
                capabilities = capabilities,
            })
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
            local signs = {
                Error = "󰅚 ",
                Warn = "󰳦 ",
                Hint = "󱡄 ",
                Info = " ",
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
            end

            vim.lsp.handlers["textDocument/publishDiagnostics"] =
                vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {
                    virtual_text = true,
                    signs = true,
                    underline = true,
                    update_on_insert = false,
                })
        end,
    },
}
