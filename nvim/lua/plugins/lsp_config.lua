---@diagnostic disable: lowercase-global, undefined-global
return {
    {
        "j-hui/fidget.nvim",
        tag = "v1.0.0",
        lazy = true,
        event = "InsertEnter",
        config = function()
            require("fidget").setup({})
        end,
    },
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
                    "pylsp",
                    "yamlls",
                    "jsonls",
                    "zls",
                    "marksman",
                    "harper_ls",
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        lazy = true,
        event = { "VeryLazy", "BufReadPre", "BufNewFile" },
        config = function()
            local capabilities = require("cmp_nvim_lsp").default_capabilities()
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
            require("lspconfig").clangd.setup({
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
            -- Install with: pip install "python-lsp-server[all]"
            lspconfig.pylsp.setup({
                capabilities = capabilities,
                settings = {
                    pylsp = {
                        plugins = {
                            -- Install: pip install `pylsp-mypy`
                            pylsp_mypy = { enabled = true },
                            mccabe = { enabled = true },
                            rope = { enabled = true },
                            jedi_completion = { fuzzy = true },
                            rope_autoimport = { enabled = true },
                            -- Delegated to ruff-lsp
                            pycodestyle = { enabled = false },
                            pyflakes = { enabled = false },
                            autopep8 = { enabled = false },
                            yapf = { enabled = false },
                            pylint = { enabled = false },
                            ruff = { enabled = false },
                            black = { enabled = false },
                            ipyls_isort = { enabled = false },
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
                    linters = {
                        userDictPath = "~/harper_ls.txt",
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
            local signs = {
                Error = "󰅚 ",
                Warn = "󰳦 ",
                Hint = "󱡄 ",
                Info = " "
            }
            for type, icon in pairs(signs) do
                local hl = "DiagnosticSign" .. type
                vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = nil })
            end

            vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics,
                {
                    virtual_text = true,
                    signs = true,
                    underline = true,
                    update_on_insert = false,
                })
        end,
    },
}
