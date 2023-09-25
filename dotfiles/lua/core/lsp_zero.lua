-- Format Rust Code on Save
local format_sync_grp = vim.api.nvim_create_augroup("Format", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format {
            timeout_ms = 300,
        }
    end,
    group = format_sync_grp,
})

-- Diagnostics
-- https://github.com/VonHeikemen/lsp-zero.nvim#diagnostics
vim.diagnostic.config {
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = true,
    virtual_text = { spacing = 4, prefix = "●" },
}


-- LSP Zero
local lsp_zero = require('lsp-zero')
lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', {buffer = bufnr})
end)

-- Autocompletion
local cmp = require('cmp')
cmp.setup({
    preselect = 'item',
    completion = {
        completeopt = "menu,menuone,noinsert",
    },
    mapping = lsp_zero.defaults.cmp_mappings {
        ["<C-Space>"] = cmp.mapping.complete(),
        ['<CR>'] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
        }),
        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            else
                fallback()
            end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            else
                fallback()
            end
        end, { "i", "s" }),
    },
    sources = {
        {
            name = "nvim_lsp",
        },
        {
            name = "buffer",
        },
        {
            name = "nvim_lsp_signature_help",
        },
        {
            name = "path",
        },
        {
            name = "nvim_lua",
        },
        {
            name = "treesitter",
        },
        {
            name = "calc",
        },
        {
            name = "crates",
        },
        {
            name = "rg",
        },
    },
    experimental = {
        ghost_text = {
            hl_group = "LspCodeLens",
        },
    },
    sorting = {
        comparators = {
            cmp.config.compare.kind,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            require("cmp-under-comparator").under,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
    },
})

require('lspconfig').lua_ls.setup({
    settings = {
        ["Lua"] = {
            format = {
                enable = true,
            },
            runtime = {
                version = "LuaJIT",
            },
            diagnostics = {
                globals = {
                    "vim",
                    "describe",
                    "it",
                    "setup",
                    "teardown",
                },
            },
            workspace = {
                library = vim.api.nvim_get_runtime_file("", true),
                checkThirdParty = false,
            },
            telemetry = {
                enable = false,
            },
        },
    },
})
require('lspconfig').rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
            },
            assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
            },
            checkOnSave = {
                command = "clippy",
                extraArgs = { "--no-deps" },
            },
            inlayHints = {
                locationLinks = true,
                parameter_hints_prefix = "  <-  ",
                other_hints_prefix = "  =>  ",
                highlight = "LspCodeLens",
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true,
                },
            },
        },
    },
})
require('lspconfig').tsserver.setup({
    settings = {
        filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
        root_dir = function() return vim.loop.cwd() end
    }
})
require('lspconfig').ruff_lsp.setup({})
require('lspconfig').pylsp.setup({
    settings = {
        pylsp = {
            plugins = {
                -- Disabled
                pylsp_mypy = { enabled = false },
                mccabe = { enabled = false },
                rope = { enabled = false },
                pycodestyle = { enabled = false },
                pyflakes = { enabled = false },
                autopep8 = { enabled = false },
                yapf = { enabled = false },
                pylint = { enabled = false },
                ruff = { enabled = false }, -- using ruff_lsp
                -- Enabled
                jedi_completion = { fuzzy = true },
                black = { enabled = true },
                ipyls_isort = { enabled = true },
                rope_autoimport = { enabled = true },
            },
        },
    },
})

-- Mason
require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {},
    handlers = {
        lsp_zero.default_setup,
    },
})

-- Completion
