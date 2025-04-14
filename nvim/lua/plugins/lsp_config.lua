return {
    {
        'neovim/nvim-lspconfig',
        event = {"BufReadPre", "BufNewFile"},
        dependencies = {
            {'williamboman/mason.nvim'}, {'williamboman/mason-lspconfig.nvim'},
            {
                "pest-parser/pest.vim",
                event = "LspAttach",
                ft = "pest",
                lazy = true,
                enabled = false
            },
            {"MysticalDevil/inlay-hints.nvim", lazy = true, event = "LspAttach"},
            {"vxpm/ferris.nvim"}, {
                'saghen/blink.cmp',
                lazy = true,
                enabled = true,
                event = "LspAttach",
                version = '1.*',
                dependencies = {
                    {"mikavilpas/blink-ripgrep.nvim"},
                    {"ribru17/blink-cmp-spell"},
                    {"giuxtaposition/blink-cmp-copilot", enabled = true},
                    {
                        "saghen/blink.pairs",
                        version = "*",
                        dependencies = {"saghen/blink.download"}
                    }
                },
                opts = {
                    appearance = {use_nvim_cmp_as_default = true},
                    completion = {
                        keyword = {range = "prefix"},
                        ghost_text = {enabled = true},
                        list = {
                            selection = {preselect = false, auto_insert = true}
                        },
                        menu = {
                            auto_show = true,
                            border = "rounded",
                            draw = {treesitter = {"lsp"}}
                        },
                        documentation = {
                            auto_show = true,
                            window = {border = "rounded"},
                            treesitter_highlighting = true
                        },
                        trigger = {show_on_insert_on_trigger_character = true}
                    },
                    fuzzy = {implementation = "rust"},
                    keymap = {preset = "enter"},
                    signature = {enabled = true, window = {border = "rounded"}},
                    sources = {
                        default = {
                            "lsp", "path", "snippets", "cmdline", "buffer",
                            "ripgrep", "spell", "copilot"
                        },
                        providers = {
                            ripgrep = {
                                module = "blink-ripgrep",
                                name = "Ripgrep",
                                min_keyword_length = 1
                            },
                            lsp = {
                                name = "LSP",
                                module = "blink.cmp.sources.lsp",
                                min_keyword_length = 0
                            },
                            spell = {name = "Spell", module = "blink-cmp-spell"},
                            omni = {
                                name = "Omni",
                                module = "blink.cmp.sources.complete_func"
                            },
                            copilot = {
                                name = "copilot",
                                module = "blink-cmp-copilot",
                                score_offset = 100,
                                async = true
                            }
                        }
                    }
                }
            }
        },
        config = function()
            local capabilities = require("blink.cmp").get_lsp_capabilities()
            local servers = {
                bashls = {
                    cmd = {"bash-language-server", "start"},
                    filetypes = {"bash", "sh", "zsh"},
                    root_markers = {".git", vim.uv.cwd()},
                    settings = {
                        bashIde = {
                            globPattern = vim.env.GLOB_PATTERN or
                                "*@(.sh|.inc|.bash|.command)"
                        }
                    },
                    capabilities = capabilities
                },
                basedpyright = {
                    settings = {
                        basedpyright = {
                            disableOrganizeImports = true,
                            analysis = {
                                autoSearchPaths = true,
                                autoImportCompletions = true,
                                useLibraryCodeForTypes = true,
                                diagnosticMode = "openFilesOnly",
                                typeCheckingMode = "strict",
                                inlayHints = {
                                    variableTypes = true,
                                    callArgumentNames = true,
                                    functionReturnTypes = true,
                                    genericTypes = false
                                }
                            }
                        }
                    },
                    capabilities = capabilities
                },
                harper_ls = {
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
                            multiple_sequential_pronouns = true
                        }
                    },
                    capabilities = capabilities
                },
                lua_ls = {
                    filetypes = {"lua"},
                    settings = {
                        Lua = {
                            telemetry = {enable = false},
                            diagnostics = {disable = {'missing-fields'}},
                            hint = {enable = true}
                        }
                    },
                    on_init = function(client)
                        if client.workspace_folders then
                            local path = client.workspace_folders[1].name
                            if path ~= vim.fn.stdpath('config') and
                                ---@diagnostic disable-next-line: undefined-field
                                (vim.uv.fs_stat(path .. '/.luarc.json') or
                                    ---@diagnostic disable-next-line: undefined-field
                                    vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
                                return
                            end
                        end
                        client.config.settings.Lua =
                            vim.tbl_deep_extend('force',
                                                client.config.settings.Lua, {
                                runtime = {version = 'LuaJIT'},
                                workspace = {
                                    checkThirdParty = false,
                                    library = {vim.env.VIMRUNTIME}
                                }
                            })
                    end,
                    capabilities = capabilities
                },
                marksman = {capabilities = capabilities},
                pest_ls = {capabilities = capabilities},
                ruff = {capabilities = capabilities},
                rust_analyzer = {
                    filetypes = {"rust"},
                    capabilities = capabilities,
                    ["rust-analyzer"] = {
                        cargo = {
                            features = "all",
                            buildScripts = {enable = true}
                        },
                        checkOnSave = {command = "check"},
                        diagnostics = {enable = true},
                        inlayHints = {
                            enable = true,
                            locationLinks = false,
                            parameter_hints_prefix = "  <-  ",
                            other_hints_prefix = "  =>  ",
                            highlight = "LspCodeLens",
                            lifetimeElisionHints = {
                                enable = true,
                                useParameterNames = true
                            }
                        },
                        lens = {
                            enable = true,
                            methodReferences = true,
                            references = true,
                            implementations = false
                        },
                        interpret = {tests = true},
                        rustfmt = {overrideCommand = "cargo +nightly fmt"},
                        procMacro = {
                            enable = true,
                            ignored = {leptos_macro = {"component", "server"}}
                        }
                    }
                },
                taplo = {capabilities = capabilities},
                ts_ls = {capabilities = capabilities}
            }
            local ensure_installed = vim.tbl_keys(servers or {})
            require('mason').setup({
                PATH = "prepend",
                registries = {
                    "github:crashdummyy/mason-registry",
                    "github:mason-org/mason-registry"
                }
            })
            require('mason-lspconfig').setup({
                ensure_installed = ensure_installed
            })
            for server, settings in pairs(servers) do
                vim.lsp.config(server, settings)
                vim.lsp.enable(server)
            end
            require("inlay-hints").setup({})

            -- Diagnostics {{{
            vim.diagnostic.config({
                signs = {
                    numhl = {
                        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
                        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
                        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
                        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn"
                    },
                    text = {
                        [vim.diagnostic.severity.ERROR] = "",
                        [vim.diagnostic.severity.HINT] = "",
                        [vim.diagnostic.severity.INFO] = "",
                        [vim.diagnostic.severity.WARN] = ""
                    }
                },
                update_in_insert = true,
                virtual_text = true,
                underline = true,
                severity_sort = true
            })
            -- }}}

            -- Improve LSPs UI {{{
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
                Variable = " "
            }

            local completion_kinds = vim.lsp.protocol.CompletionItemKind
            for i, kind in ipairs(completion_kinds) do
                completion_kinds[i] = icons[kind] and icons[kind] .. kind or
                                          kind
            end
            -- }}}
        end
    }
}
