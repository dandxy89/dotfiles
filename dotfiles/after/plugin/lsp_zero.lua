local lsp = require("lsp-zero")

lsp.preset("recommended")

lsp.ensure_installed({'tsserver', 'pyright', 'sumneko_lua', 'rust_analyzer'})

local cmp = require('cmp')
local cmp_select = {
    behavior = cmp.SelectBehavior.Select
}
local cmp_mappings = lsp.defaults.cmp_mappings({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({
        select = true
    }),
    ["<C-Space>"] = cmp.mapping.complete()
})

lsp.setup_nvim_cmp({
    mapping = cmp_mappings
})

lsp.configure('pyright', {
    flags = {
        debounce_text_changes = 150
    }
})

lsp.setup_nvim_cmp({
    sources = {{
        name = 'path',
        keyword_length = 2,
        max_item_count = 10
    }, {
        name = 'nvim_lsp',
        keyword_length = 1
    }, {
        name = 'nvim_lsp_signature_help',
        keyword_length = 1
    }, {
        name = 'nvim_lua',
        keyword_length = 1
    }, {
        name = 'luasnip',
        max_item_count = 10
    }, {
        name = 'buffer',
        keyword_length = 1,
        max_item_count = 10
    }, {
        name = 'vsnip'
    }, {
        name = 'treesitter',
        max_item_count = 10
    }, {
        name = 'calc'
    }, {
        name = 'rg',
        max_item_count = 10
    }}
})

local rust_lsp = lsp.build_options('rust_analyzer', {
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
})

lsp.set_preferences({
    suggest_lsp_servers = false,
    sign_icons = {
        error = 'E',
        warn = 'W',
        hint = 'H',
        info = 'I'
    }
})

vim.diagnostic.config({
    virtual_text = true
})

lsp.on_attach(function(_, bufnr)
    local opts = {
        buffer = bufnr,
        remap = false,
        nowait = true,
        silent = true
    }
    vim.keymap.set("n", "<leader>rn", function()
        vim.lsp.buf.rename()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>gr", function()
        vim.lsp.buf.lsp_references()
    end, opts)
    vim.keymap.set("n", "<leader>ca", function()
        vim.lsp.buf.code_action()
    end, opts)
    vim.keymap.set("n", "<leader>gd", function()
        vim.lsp.buf.definition()
    end, opts)
    vim.keymap.set("n", "<leader>gi", function()
        vim.lsp.buf.implementation()
    end, opts)
    vim.keymap.set("n", "<leader>sh", function()
        vim.lsp.buf.signature_help()
    end, opts)
    vim.keymap.set("n", "K", function()
        vim.lsp.buf.hover()
    end, opts)
end)

lsp.setup()

require('rust-tools').setup({
    server = rust_lsp
})

require("luasnip.loaders.from_vscode").lazy_load()

-- Format Rust Code on Save
local format_sync_grp = vim.api.nvim_create_augroup("Format", {})
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({
            timeout_ms = 300
        })
    end,
    group = format_sync_grp
})
