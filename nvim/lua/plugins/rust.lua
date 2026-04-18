return {
  {
    'vxpm/ferris.nvim',
    event = { 'FileType rust' },
    config = function()
      vim.keymap.set('n', '<Leader>ml', function() require('ferris.methods.view_memory_layout')() end, { desc = 'Ferris memory layout' })
      vim.keymap.set('n', '<Leader>em', function() require('ferris.methods.expand_macro')() end, { desc = 'Ferris expand macro' })
      vim.keymap.set('n', '<Leader>od', function() require('ferris.methods.open_documentation')() end, { desc = 'Ferris open documentation' })
    end,
  },

  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml', 'BufNewFile Cargo.toml' },
    config = function()
      require('crates').setup()
    end,
  },
}
