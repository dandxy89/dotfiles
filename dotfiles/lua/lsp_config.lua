-- Add additional capabilities supported by nvim-cmp
require("mason").setup()
require("mason-lspconfig").setup()

local lspconfig = require("lspconfig")
local lsp_defaults = lspconfig.util.default_config

lsp_defaults.capabilities = vim.tbl_deep_extend('force', lsp_defaults.capabilities,
    require('cmp_nvim_lsp').default_capabilities())

-- capabilities = require('cmp_nvim_lsp').default_capabilities()

local cmp = require('cmp')
local lspconfig = require('lspconfig')
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done())
cmp.setup({
    preselect = cmp.PreselectMode.None,
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
        keyword_length = 1,
        max_item_count = 15
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

require('lspconfig').marksman.setup {
    flags = {
        debounce_text_changes = 150
    }
}
require('lspconfig').pyright.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150
    }
}
require('lspconfig').tsserver.setup {
    on_attach = on_attach,
    flags = {
        debounce_text_changes = 150
    }
}

require('rust-tools').setup({
    flags = {
        debounce_text_changes = 150
    },
    server = {
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
                    command = "check" -- "clippy",
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
        inlay_hints = {
            auto = true,
            show_parameter_hints = false,
            parameter_hints_prefix = "",
            other_hints_prefix = ""
        }
    }
})

require('Comment').setup()
require('hlargs').setup()
require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "cmake", "dockerfile", "hcl", "help", "http", "json", "lua", "make", "markdown",
                        "python", "regex", "rust", "toml", "vim", "yaml"},
    -- auto_install = true,
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
