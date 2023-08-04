-- 99cf111289bfcd14981255e805da43bac5139141
local lsp = require "lsp-zero"

lsp.preset {
  name = "minimal",
  set_lsp_keymaps = true,
  manage_nvim_cmp = true,
  suggest_lsp_servers = true,
}
lsp.skip_server_setup { "rust_analyzer" }
lsp.ensure_installed {
  "tsserver",
  "lua_ls",
  "rust_analyzer",
  "ruff_lsp",
  "taplo",
  "pylsp",
}
lsp.on_attach(function(client, bufnr)
  lsp.default_keymaps({buffer = bufnr, preserve_mappings = false})
end)
-- lsp.nvim_workspace()

local cmp = require "cmp"

-- https://github.com/VonHeikemen/lsp-zero.nvim#autocompletion
lsp.setup_nvim_cmp {
  completion = {
    completeopt = "menu,menuone,noinsert",
  },
  mapping = lsp.defaults.cmp_mappings {
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
    -- {
    --   name = "luasnip",
    -- },
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
}

-- https://github.com/python-lsp/python-lsp-server
-- pip install python-lsp-isort
-- pip install python-lsp-black
--
lsp.configure("pylsp", {
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
        -- Enabled
        jedi_completion = { fuzzy = true },
        black = { enabled = true },
        ipyls_isort = { enabled = true },
        ruff = { enabled = true },
        rope_autoimport = {
          enabled = true,
        },
      },
    },
    ruff_lsp = {
      diagnostics = {
        -- Get the language server to recognize the `vim` global
        globals = { "vim" },
      },
      workspace = {
        -- Make the server aware of Neovim runtime files
        library = vim.api.nvim_get_runtime_file("", true),
      },
    },
  },
  flags = {
    debounce_text_changes = 200,
  },
})

lsp.configure("tsserver", {
  settings = {
    filetypes = { "javascript", "typescript", "typescriptreact", "typescript.tsx" },
    root_dir = function() return vim.loop.cwd() end
  }
})

lsp.configure("lua_ls", {
  settings = {
    Lua = {
      format = {
        enable = false,
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

lsp.set_preferences {
  suggest_lsp_servers = true,
  sign_icons = {
    error = "E",
    warn = "W",
    hint = "H",
    info = "I",
  },
}

lsp.setup()

-- Initialize rust_analyzer with rust-tools
-- https://github.com/VonHeikemen/lsp-zero.nvim#build_optionsserver-opts
local rust_lsp = lsp.build_options("rust_analyzer", {
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
require("rust-tools").setup { server = rust_lsp }

lsp.default_keymaps({
  buffer = bufnr,
  preserve_mappings = false
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

-- Snippets
require("luasnip.loaders.from_vscode").lazy_load()

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
