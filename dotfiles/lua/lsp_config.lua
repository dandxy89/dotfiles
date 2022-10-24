-- Add additional capabilities supported by nvim-cmp
capabilities = require('cmp_nvim_lsp').default_capabilities()

local cmp = require('cmp')

local lspconfig = require('lspconfig')

cmp.setup({
    snippet = {
        -- REQUIRED by nvim-cmp. get rid of it once we can
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body)
        end
    },
    mapping = {
        -- Tab immediately completes. C-n/C-p to select.
        ['<Tab>'] = cmp.mapping.confirm({
            select = true
        }),
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
    }, -- file paths
    {
        name = 'nvim_lsp',
        keyword_length = 3
    }, -- from language server
    {
        name = 'nvim_lsp_signature_help'
    }, -- display function signatures with current parameter emphasized
    {
        name = 'nvim_lua',
        keyword_length = 2
    }, -- complete neovim's Lua runtime API such vim.lsp.*
    {
        name = 'buffer',
        keyword_length = 2
    }, -- source current buffer
    {
        name = 'vsnip',
        keyword_length = 2
    }, -- nvim-cmp source for vim-vsnip 
    {
        name = 'calc'
    }, -- source for math calculation
    {
        name = 'luasnip'
    }},
    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered()
    },
    experimental = {
        ghost_text = true
    }
})

local lsp_flags = {
    debounce_text_changes = 150
}
require('lspconfig')['pyright'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}
require('lspconfig')['tsserver'].setup {
    on_attach = on_attach,
    flags = lsp_flags,
    capabilities = capabilities
}

require('Comment').setup()
require('crates').setup()

require('nvim-treesitter.configs').setup {
    ensure_installed = {"bash", "c", "cmake", "css", "dockerfile", "go", "gomod", "gowork", "hcl", "help", "html",
                        "http", "javascript", "json", "lua", "make", "markdown", "python", "regex", "ruby", "rust",
                        "toml", "vim", "yaml", "zig"},
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
                    -- default: `cargo clippy`
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
    }
}

require('rust-tools').setup(rt)
require('hlargs').setup()

-- LSP Diagnostics Options Setup 
local sign = function(opts)
    vim.fn.sign_define(opts.name, {
        texthl = opts.name,
        text = opts.text,
        numhl = ''
    })
end

sign({
    name = 'DiagnosticSignError',
    text = ''
})
sign({
    name = 'DiagnosticSignWarn',
    text = ''
})
sign({
    name = 'DiagnosticSignHint',
    text = ''
})
sign({
    name = 'DiagnosticSignInfo',
    text = ''
})

vim.diagnostic.config({
    virtual_text = false,
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = {
        border = 'rounded',
        source = 'always',
        header = '',
        prefix = ''
    }
})

vim.cmd([[
  set signcolumn=yes
  autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

