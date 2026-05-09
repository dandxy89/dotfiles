return {
  {
    'saghen/blink.cmp',
    name = 'blink-cmp',
    branch = 'v2',
    event = { 'InsertEnter', 'CmdlineEnter' },
    dependencies = { 'blink-lib', 'blink-ripgrep.nvim', 'blink-cmp-spell', 'blink-cmp-dat-word' },
    build = function()
      vim.cmd.packadd('blink-lib')
      vim.cmd.packadd('blink-cmp')
      require('blink.cmp').build():wait(60000)
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
          default = { 'lsp', 'path', 'snippets', 'buffer', 'ripgrep', 'spell', 'datword', 'omni' },
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
            spell = { name = 'Spell', module = 'blink-cmp-spell' },
            omni = { name = 'Omni', module = 'blink.cmp.sources.complete_func' },
            datword = {
              name = 'Word',
              module = 'blink-cmp-dat-word',
              opts = {
                paths = { vim.fn.stdpath('data') .. '/google-10000-english.txt' },
              },
            },
          },
        },
      })
    end,
  },

  {
    'saghen/blink.pairs',
    name = 'blink-pairs',
    event = { 'InsertEnter' },
    build = 'cargo build --release',
  },

  { 'saghen/blink.lib', name = 'blink-lib' },
  { 'mikavilpas/blink-ripgrep.nvim' },
  { 'ribru17/blink-cmp-spell' },

  {
    'xieyonn/blink-cmp-dat-word',
    build = function()
      local dest = vim.fn.stdpath('data') .. '/google-10000-english.txt'
      vim
        .system({
          'curl',
          '-fsSL',
          '-o',
          dest,
          'https://raw.githubusercontent.com/first20hours/google-10000-english/master/google-10000-english.txt',
        })
        :wait()
    end,
  },
}
