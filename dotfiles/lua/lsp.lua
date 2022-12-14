-- Add additional capabilities supported by nvim-cmp
require("mason").setup()
require("mason-lspconfig").setup()

local ih = require("inlay-hints")
local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities())

local cmp = require('cmp')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
cmp.setup({
    preselect = cmp.PreselectMode.None,
    experimental = {
        ghost_text = true
    },
    snippet = {
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        ['<C-p>'] = cmp.mapping.select_prev_item(),
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<S-Tab>'] = cmp.mapping.select_prev_item(),
        ['<Tab>'] = cmp.mapping.select_next_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), {'i', 'c'}),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Insert,
            select = true
        })
    },
    sorting = {
        comparators = {cmp.config.compare.offset, cmp.config.compare.exact, cmp.config.compare.score,
                       require"cmp-under-comparator".under, cmp.config.compare.kind, cmp.config.compare.sort_text,
                       cmp.config.compare.length, cmp.config.compare.order}
    },
    sources = {{
        name = 'path',
        keyword_length = 2,
        max_item_count = 5
    }, {
        name = 'nvim_lsp',
        keyword_length = 1
    }, {
        name = 'nvim_lsp_signature_help',
        keyword_length = 2
    }, {
        name = 'nvim_lua',
        keyword_length = 2
    }, {
        name = 'buffer',
        keyword_length = 1,
        max_item_count = 10
    }, {
        name = 'vsnip'
    }, {
        name = 'rg',
        max_item_count = 10
    }},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    }
})

-- Markdown
lspconfig.marksman.setup {
    flags = {
        debounce_text_changes = 150
    }
}

-- Python
lspconfig.pyright.setup {
    flags = {
        debounce_text_changes = 150
    },
    settings = {
        pyright = {
            autoImportCompletion = true,
            reportUnusedFunction = true,
            reportUnusedVariable = false
        },
        python = {
            analysis = {
                useLibraryCodeForTypes = true,
                typeCheckingMode = 'off',
                autoImportCompletions = true,
                diagnosticMode = 'workspace'
            }
        }
    }
}

-- Lua
local runtime_path = vim.split(package.path, ";")
table.insert(runtime_path, "lua/?.lua")
table.insert(runtime_path, "lua/?/init.lua")
lspconfig.sumneko_lua.setup({
    on_attach = function(c, b)
        ih.on_attach(c, b)
    end,
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = runtime_path
            },
            diagnostics = {
                globals = {"vim"}
            },
            telemetry = {
                enable = false
            },
            hint = {
                enable = true
            }
        }
    }
})

-- TypeScript
require('lspconfig').tsserver.setup {
    cmd = {"typescript-language-server", "--stdio"},
    filetypes = {"typescript", "typescriptreact", "typescript.tsx"},
    flags = {
        debounce_text_changes = 150
    },
    on_attach = function(c, b)
        ih.on_attach(c, b)
    end,
    settings = {
        javascript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true
            }
        },
        typescript = {
            inlayHints = {
                includeInlayEnumMemberValueHints = true,
                includeInlayFunctionLikeReturnTypeHints = true,
                includeInlayFunctionParameterTypeHints = true,
                includeInlayParameterNameHints = "all", -- 'none' | 'literals' | 'all';
                includeInlayParameterNameHintsWhenArgumentMatchesName = true,
                includeInlayPropertyDeclarationTypeHints = true,
                includeInlayVariableTypeHints = true
            }
        }
    }
}

-- Rust
require('rust-tools').setup({
    flags = {
        debounce_text_changes = 150
    },
    server = {
        on_attach = function(c, b)
            ih.on_attach(c, b)
        end,
        settings = {
            ["rust-analyzer"] = {
                assist = {
                    importEnforceGranularity = true,
                    importPrefix = "crate"
                },
                cargo = {
                    allFeatures = true
                },
                checkOnSave = {
                    command = "clippy"
                },
                inlayHints = {
                    lifetimeElisionHints = {
                        enable = true,
                        useParameterNames = true
                    }
                }
            }
        }
    },
    tools = {
        runnables = {
            use_telescope = true
        },
        on_initialized = function()
            ih.set_all()
        end,
        inlay_hints = {
            auto = false
        }
    }
})

-- Highlight Arguments
require('hlargs').setup()

-- Treesitter Config
require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "cmake", "dockerfile", "hcl", "help", "http", "json", "lua", "make", "markdown",
                        "python", "regex", "rust", "toml", "vim", "yaml"},
    auto_install = true,
    highlight = {
        enable = true
    },
    ident = {
        enable = true
    },
    rainbow = {
        enable = true,
        extended_mode = true,
        max_file_lines = nil
    }
}

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Format Rust Code on Save
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({
            timeout_ms = 200
        })
    end,
    group = format_sync_grp
})
