--       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
--       ╏                                                               ╏
--       ╏                            LSP Config                         ╏
--       ╏                                                               ╏
--       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

-- Format Rust Code on Save
local format_sync_grp = vim.api.nvim_create_augroup("Format", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
    pattern = "*.rs",
    callback = function()
        vim.lsp.buf.format({
            timeout_ms = 300,
        })
    end,
    group = format_sync_grp,
})

-- LSP Zero
local lsp_zero = require("lsp-zero")
lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
end)

-- Autocompletion
local cmp = require("cmp")
local lspkind = require("lspkind")
cmp.setup({
    preselect = "item",
    snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
            ---@diagnostic disable-next-line: undefined-global
            luasnip.lsp_expand(args.body)
        end,
    },
    mapping = lsp_zero.defaults.cmp_mappings({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<CR>"] = cmp.mapping.confirm({
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
    }),
    sources = {
        { name = "codeium" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" }, -- nvim_lsp
        { name = "buffer" },   -- cmp-buffer
        { name = "treesitter" },
        { name = "luasnip" },  -- snippets
        { name = "path" },
        { name = "rg" },
        { name = "crates" },
        { name = "nvim-lsp" },
    },
    experimental = {
        ghost_text = true,
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
    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol",       -- show only symbol annotations
            maxwidth = 50,         -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = "...", -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)
            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(_, vim_item)
                -- ...
                return vim_item
            end,
        }),
    },
})

-- Cmp colouring
vim.api.nvim_set_hl(0, "CmpItemAbbrDeprecated", { bg = "NONE", strikethrough = true, fg = "#808080" }) -- gray
vim.api.nvim_set_hl(0, "CmpItemAbbrMatch", { bg = "NONE", fg = "#569CD6" })                            -- blue
vim.api.nvim_set_hl(0, "CmpItemAbbrMatchFuzzy", { link = "CmpIntemAbbrMatch" })                        -- blue
vim.api.nvim_set_hl(0, "CmpItemKindVariable", { bg = "NONE", fg = "#9CDCFE" })                         -- light blue
vim.api.nvim_set_hl(0, "CmpItemKindInterface", { link = "CmpItemKindVariable" })                       -- light blue
vim.api.nvim_set_hl(0, "CmpItemKindText", { link = "CmpItemKindVariable" })                            -- light blue
vim.api.nvim_set_hl(0, "CmpItemKindFunction", { bg = "NONE", fg = "#C586C0" })                         -- pink
vim.api.nvim_set_hl(0, "CmpItemKindMethod", { link = "CmpItemKindFunction" })                          -- pink
vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { bg = "NONE", fg = "#D4D4D4" })                          -- front
vim.api.nvim_set_hl(0, "CmpItemKindProperty", { link = "CmpItemKindKeyword" })                         -- front
vim.api.nvim_set_hl(0, "CmpItemKindUnit", { link = "CmpItemKindKeyword" })                             -- front

--
require("luasnip.loaders.from_vscode").lazy_load({})

-- Custom LSP configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()
require("lspconfig").lua_ls.setup({
    settings = {
        Lua = {
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
            flags = { debounce_text_changes = 300 },
        },
    },
    capabilities = capabilities,
})
require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                allFeatures = true,
                buildScripts = {
                    enable = true,
                }
            },
            assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
            },
            checkOnSave = {
                -- command = "clippy",
                command = "check",
            },
            diagnostics = {
                enable = true;
            },
            inlayHints = {
                locationLinks = true,
                parameter_hints_prefix = "  <-  ",
                other_hints_prefix = "  =>  ",
                highlight = "LspCodeLens",
                lifetimeElisionHints = { enable = true, useParameterNames = true },
            },
            telemetry = { enable = false },
            flags = { debounce_text_changes = 300 },
            procMacro = {
                enable = true
            },
            add_return_type = {
                enable = true
            },
        }
    }
})
require("lspconfig").tsserver.setup({
    settings = {
        tsserver = {
            filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
            ---@diagnostic disable-next-line: undefined-field
            root_dir = function()
                ---@diagnostic disable-next-line: undefined-field
                return vim.loop.cwd()
            end,
        },
    },
    capabilities = capabilities,
})
require("lspconfig").ruff_lsp.setup({
    settings = {
        organizeImports = false,
    },
    capabilities = capabilities,
})
require("lspconfig").pylsp.setup({
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
        flags = { debounce_text_changes = 300 },
        telemetry = {
            enable = false,
        },
    },
    capabilities = capabilities,
})

-- Mason
require("mason").setup({})
require("mason-lspconfig").setup({
    ensure_installed = {
        "tsserver",
        "yamlls",
        "zls",
        "dockerls",
        "lua_ls",
        "pylsp",
        "ruff_lsp",
        "rust_analyzer",
        "pest_ls",
    },
    handlers = {
        lsp_zero.default_setup,
    },
})

-- Diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = "🆇", texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = "⚠️", texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = "ℹ️", texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

-- Diagnostics
-- https://github.com/VonHeikemen/lsp-zero.nvim#diagnostics
vim.diagnostic.config({
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = false,
    float = true,
    virtual_text = { spacing = 4, prefix = "●" },
})

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = "rounded",
})
