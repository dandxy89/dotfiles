return {
  {
    'saghen/blink.cmp',
    name = 'blink-cmp',
    -- v2 (UPGRADE.md): requires Neovim 0.12+ and blink.lib; build():pwait()
    -- fetches the fuzzy binary via blink.lib, so no Rust toolchain is needed.
    -- v2 is untagged and lives on main; pin vim.version.range('2')
    -- once v2.0.0 is released.
    version = 'main',
    -- Eager: blink's plugin file merges its capabilities into vim.lsp.config('*'),
    -- which must happen before LSP servers attach at startup
    lazy = false,
    dependencies = { 'blink-lib', 'blink-ripgrep.nvim' },
    build = function()
      vim.cmd.packadd('blink-lib')
      vim.cmd.packadd('blink-cmp')
      -- On a release tag build() downloads the prebuilt fuzzy binary (no
      -- toolchain needed); :pwait() matches :h blink-cmp-installation, waits
      -- without a fixed timeout, and won't throw if the download/build fails.
      require('blink.cmp').build():pwait()
    end,
    config = function()
      require('blink.cmp').setup({
        completion = {
          keyword = { range = 'prefix' },
          ghost_text = { enabled = true },
          list = {
            selection = { preselect = false, auto_insert = true },
          },
          menu = {
            auto_show = true,
            border = 'rounded',
            draw = { treesitter = { 'lsp' } },
          },
          documentation = {
            auto_show = true,
            window = { border = 'rounded' },
            treesitter_highlighting = true,
            auto_show_delay_ms = 150,
          },
          trigger = { show_on_insert_on_trigger_character = true },
        },
        fuzzy = { implementation = 'prefer_rust_with_warning' },
        keymap = { preset = 'enter' },
        signature = { enabled = true, window = { border = 'rounded' } },
        cmdline = {
          enabled = true,
          sources = { default = { 'cmdline', 'path' } },
        },
        sources = {
          default = { 'lsp', 'path', 'snippets', 'buffer', 'ripgrep' },
          providers = {
            ripgrep = {
              module = 'blink-ripgrep',
              name = 'Ripgrep',
              min_keyword_length = 3,
            },
            lsp = {
              name = 'LSP',
              module = 'blink.cmp.sources.lsp',
              min_keyword_length = 0,
            },
          },
        },
      })
    end,
  },

  { 'saghen/blink.lib', name = 'blink-lib' },
  { 'mikavilpas/blink-ripgrep.nvim' },
}
