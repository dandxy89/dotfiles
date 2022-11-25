-- Add additional capabilities supported by nvim-cmp
require("mason").setup()
require("mason-lspconfig").setup()

capabilities = require('cmp_nvim_lsp').default_capabilities()

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
    sources = {{
        name = 'path'
    }, {
        name = 'nvim_lsp'
    }, {
        name = 'nvim_lsp_signature_help'
    }, {
        name = 'nvim_lua'
    }, {
        name = 'buffer'
    }, {
        name = 'vsnip'
    }, {
        name = 'luasnip'
    }},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    }
})

local lsp_flags = {
    debounce_text_changes = 150
}
require('lspconfig').marksman.setup {}
require('lspconfig').pyright.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}
require('lspconfig').tsserver.setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}

local rt = {
    capabilities = capabilities,
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
                    command = "check"
                    -- command = "clippy",
                },
                inlayHints = {
                    lifetimeElisionHints = {
                        enable = true,
                        useParameterNames = true
                    }
                }
            }
        }
    }
}

require('Comment').setup()
require('crates').setup()
require('rust-tools').setup(rt)
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
