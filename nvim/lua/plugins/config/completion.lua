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
  fuzzy = { implementation = 'rust' },
  keymap = { preset = 'enter' },
  signature = { enabled = true, window = { border = 'rounded' } },
  sources = {
    default = {
      'lsp',
      'path',
      'snippets',
      'cmdline',
      'buffer',
      'ripgrep',
      'spell',
    },
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
      omni = {
        name = 'Omni',
        module = 'blink.cmp.sources.complete_func',
      },
    },
  },
})
