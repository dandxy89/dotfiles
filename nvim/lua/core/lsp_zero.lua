-- --       ┏╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┓
-- --       ╏                                                               ╏
-- --       ╏                            LSP Config                         ╏
-- --       ╏                                                               ╏
-- --       ┗╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍╍┛

local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
    return
end

local lsp_zero_status_ok, lsp_zero = pcall(require, "lsp-zero")
if not lsp_zero_status_ok then
    return
end

-- find more here: https://www.nerdfonts.com/cheat-sheet
local kind_icons = {
    Text = "󰉿",
    Method = "󰆧",
    Function = "󰊕",
    Constructor = "",
    Field = " ",
    Variable = "󰀫",
    Class = "󰠱",
    Interface = "",
    Module = "",
    Property = "󰜢",
    Unit = "󰑭",
    Value = "󰎠",
    Enum = "",
    Keyword = "󰌋",
    Snippet = "",
    Color = "󰏘",
    File = "󰈙",
    Reference = "",
    Folder = "󰉋",
    EnumMember = "",
    Constant = "󰏿",
    Struct = "",
    Event = "",
    Operator = "󰆕",
    TypeParameter = " ",
    Misc = " ",
}

-- LSP Zero
lsp_zero.on_attach(function(_, bufnr)
    lsp_zero.default_keymaps({ buffer = bufnr })
    vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<cr>", { buffer = bufnr })
end)

-- Autocompletion
---@diagnostic disable-next-line: redundant-parameter
cmp.setup({
    completion = {
        completeopt = 'menu,menuone,noinsert',
    },
    formatting = {
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
            -- Kind icons
            vim_item.kind = string.format("%s", kind_icons[vim_item.kind])
            -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
            vim_item.menu = ({
                nvim_lsp = "[LSP]",
                luasnip = "[Snippet]",
                buffer = "[Buffer]",
                path = "[Path]",
            })[entry.source.name]
            return vim_item
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
    preselect = "item",
    snippet = { -- configure how nvim-cmp interacts with snippet engine
        expand = function(args)
            ---@diagnostic disable-next-line: undefined-global
            luasnip.lsp_expand(args.body)
        end,
    },
    sources = cmp.config.sources({
        { name = "codeium" },
        { name = "nvim_lsp_signature_help" },
        { name = "nvim_lsp" }, -- nvim_lsp
        { name = "buffer" },   -- cmp-buffer
        { name = "path" },
        {
            name = 'omni',
            option = {
                disable_omnifuncs = { 'v:lua.vim.lsp.omnifunc' }
            }
        },
        { name = "rg",      keyword_length = 2 },
        { name = "crates" },
        { name = "nvim-lsp" },
        {
            name = 'spell',
            option = {
                keep_all_entries = false,
                enable_in_context = function()
                    return true
                end,
            },
        },
    }),
    experimental = {
        ghost_text = true,
        native_menu = false,
    },
    sorting = {
        comparators = {
            require("cmp-under-comparator").under,
            cmp.config.compare.kind,
            cmp.config.compare.offset,
            cmp.config.compare.exact,
            cmp.config.compare.score,
            cmp.config.compare.sort_text,
            cmp.config.compare.length,
            cmp.config.compare.order,
        },
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

-- Luasnip
-- require("luasnip.loaders.from_vscode").lazy_load({})

-- Custom LSP configuration
local capabilities = require("cmp_nvim_lsp").default_capabilities()

-- Lua
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
            flags = { debounce_text_changes = 150 },
        },
    },
    capabilities = capabilities,
})

-- OCaml
-- require("lspconfig").ocamllsp.setup({
--     cmd = { "ocamllsp" },
--     filetypes = { "ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune" },
--     root_dir = function()
--         ---@diagnostic disable-next-line: undefined-field
--         return vim.loop.cwd()
--     end,
--     capabilities = capabilities,
--     flags = { debounce_text_changes = 150 },
-- })

-- Rust
require("lspconfig").rust_analyzer.setup({
    settings = {
        ["rust-analyzer"] = {
            cargo = {
                features = "all",
                buildScripts = {
                    enable = true,
                }
            },
            assist = {
                importEnforceGranularity = true,
                importPrefix = "crate",
                emitMustUse = true,
            },
            checkOnSave = {
                command = "check",
                -- command = "clippy",
            },
            diagnostics = {
                enable = true,
            },
            inlayHints = {
                locationLinks = true,
                parameter_hints_prefix = "  <-  ",
                other_hints_prefix = "  =>  ",
                highlight = "LspCodeLens",
                lifetimeElisionHints = {
                    enable = true,
                    useParameterNames = true
                },
            },
            interpret = {
                tests = true
            },
            rustfmt = {
                overrideCommand = "cargo +nightly fmt"
            },
            procMacro = {
                enable = true
            },
            -- flags = { debounce_text_changes = 150 },
        }
    }
})
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

-- Typescript
require("lspconfig").tsserver.setup({
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
})

-- Python
require("lspconfig").ruff_lsp.setup({
    settings = {
        organizeImports = false,
    },
    capabilities = capabilities,
    flags = { debounce_text_changes = 150 },
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
                ruff = { enabled = true }, -- using ruff_lsp
                -- Enabled
                jedi_completion = { fuzzy = true },
                black = { enabled = true },
                ipyls_isort = { enabled = true },
                rope_autoimport = { enabled = true },
            },
        },
        flags = { debounce_text_changes = 150 },
        telemetry = {
            enable = false,
        },
    },
    capabilities = capabilities,
})

-- Diagnostics
local diagnosticIcons = {
    BoldError = " ",
    Error = " ",
    BoldWarning = " ",
    Warning = " ",
    BoldInformation = " ",
    Information = " ",
    BoldQuestion = " ",
    Question = " ",
    BoldHint = "",
    Hint = "󰌶",
    Debug = " ",
    Trace = "✎",
}
-- Diagnostic signs.
vim.fn.sign_define("DiagnosticSignError", { text = diagnosticIcons.Error, texthl = "DiagnosticSignError" })
vim.fn.sign_define("DiagnosticSignWarn", { text = diagnosticIcons.Warning, texthl = "DiagnosticSignWarn" })
vim.fn.sign_define("DiagnosticSignInfo", { text = diagnosticIcons.Information, texthl = "DiagnosticSignInfo" })
vim.fn.sign_define("DiagnosticSignHint", { text = diagnosticIcons.Hint, texthl = "DiagnosticSignHint" })

-- Diagnostics
-- https://github.com/VonHeikemen/lsp-zero.nvim#diagnostics
vim.diagnostic.config({
    signs = true,
    update_in_insert = true,
    underline = true,
    severity_sort = true,
    float = true,
    virtual_text = { spacing = 4, prefix = "●" },
})

-- opens a float window for diagnostics when you keep cursor on them, including full text
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

-- Change border of documentation hover window, See https://github.com/neovim/neovim/pull/13998.
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
    border = "rounded",
})

-- `:` cmdline setup.
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = 'path' }
    }, {
        {
            name = 'cmdline',
            option = {
                ignore_cmds = { 'Man', '!' }
            }
        }
    })
})

-- `/` cmdline setup.
cmp.setup.cmdline('/', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = 'buffer' }
    }
})
