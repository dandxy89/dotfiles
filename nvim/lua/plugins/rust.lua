return {
  {
    'Saecki/crates.nvim',
    event = { 'BufRead Cargo.toml', 'BufNewFile Cargo.toml' },
    config = function()
      require('crates').setup()
    end,
  },
}
